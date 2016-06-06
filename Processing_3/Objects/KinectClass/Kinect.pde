//20160510 Simplified & clean class drom Roger Dubuis R&D
//Implementation Bonjour-Lab | www.bonjour-lab.com
import KinectPV2.*;
import java.util.*;

class Kinect
{
  //Object from Library
  private KinectPV2 kinect;
  PApplet context;

  //Parameters
  private int minThreshold; //minimum distance for depth detection between 0 and 4500 where 1px = 1mm
  private int maxThreshold; //maximum distance for depth detection between 0 and 4500 where 1px = 1mm
  private static final int colorImgWidth = 1920; //Width of the color image (1920 × 1080)
  private static final int colorImgHeight = 1080; //Height of the color image (1920 × 1080)
  private static final int infaredImgWidth = 512; //Width of the infared image (515 × 424)
  private static final int infaredImgHeight = 424; //Height of the infared image (515 × 424)
  private static final float colorRatio = (float) colorImgWidth / (float) colorImgHeight;
  private static final float infaredRatio = (float) infaredImgWidth / (float) infaredImgHeight; //Ration between Width and Height of each camera images

  //Skeleton
  private ArrayList<PVector> skeletonList;
  private ArrayList<Integer> skeletonStateList;

  //Cameras intrinsic & extrinsic parameters
  //Based on Camera Calibration Tool from MRPT project
  //Depth Camera Parameters
  private static final double c_x = 256.265446519628880;
  private static final double c_y = 212.411466505718410;
  private static final double f_y = 357.304303134804570;
  private static final double f_x = 357.530142098200430;

  // RGB Camera Parameters
  private static final double c_x_R = 972.342663905029780;
  private static final double c_y_R = 532.647637932517680;
  private static final double f_y_R = 1032.664507508227000;
  private static final double f_x_R = 1033.174107119366900;

  //Kinect Rotation and Translation parameter between the two cameras
  private final double[] R = {
    0.9999, 0.0137, 0.0049, 
    -0.0137, 0.9999, 7.1164e-4, 
    -0.0049, -7.7883e-4, 1
  };
  private final double[] T = {51.9097, -0.5288, -0.5756};

  //Raw data from Kinect
  private int[] rawDepthData;
  private int[] rawBodyTrackData;

  //Array of coordinates
  private int gridResolution;
  private int newDepthWidth;
  private int newDepthHeight;
  private PVector[][] depth3DCoord;
  private PVector[][] color3DCoord;
  private PVector[][] color2DCoord;

  //frustum data
  private PVector far_0;
  private PVector far_1;
  private PVector far_2;
  private PVector far_3;
  private PVector near_0;
  private PVector near_1;
  private PVector near_2;
  private PVector near_3;


  Kinect(PApplet context_)
  {
    initKinect(context_, 0, 4500);
  }

  Kinect(PApplet context_, int minThreshold_, int maxThreshold_)
  {
    initKinect(context_, minThreshold_, maxThreshold_);
  }

  //---------------------
  // INIT METHODS
  //---------------------
  private void initKinect(PApplet context_, int minThreshold_, int maxThreshold_)
  {
    context = context_;

    //define parameteres
    minThreshold = minThreshold_;
    maxThreshold = maxThreshold_;

    kinect = new KinectPV2(context);

    //init all cameras parameters
    kinect.enableColorImg(true);
    kinect.enableDepthImg(true);
    kinect.enableBodyTrackImg(true);
    kinect.enablePointCloud(true);
    kinect.enableInfraredImg(true);
    kinect.enableSkeletonDepthMap(true); 
    kinect.enableSkeletonColorMap(true);
    kinect.enableSkeleton3DMap(true);
    kinect.enableInfraredLongExposureImg(true);
    kinect.enableDepthMaskImg(true);

    kinect.init();

    //set parameters to Kinect
    initThreshold();
    initSkeleton();
    initCoordinatesArrays(1);

    //initFrustum
    initFrustum();
  }

  private void initThreshold()
  {
    setMinDist(minThreshold);
    setMaxDist(maxThreshold);
  }

  private void initSkeleton()
  {
    skeletonList = new ArrayList<PVector>();
    skeletonStateList = new ArrayList<Integer>();
    for (int i=0; i<21; i++)
    {
      skeletonList.add(new PVector(0, 0, 0));
      skeletonStateList.add(0);
    }
  }

  private void initCoordinatesArrays(int offset_)
  {
    gridResolution = offset_;
    newDepthWidth = infaredImgWidth / offset_;
    newDepthHeight = infaredImgHeight / offset_;

    depth3DCoord = new PVector[newDepthWidth][newDepthHeight];
    color3DCoord = new PVector[newDepthWidth][newDepthHeight];
    color2DCoord = new PVector[newDepthWidth][newDepthHeight];
  }

  private void initFrustum()
  {
    float thetah = radians(70.6); //Data from Kinect lens;
    float thetav = 2 * atan(infaredImgHeight * tan(thetah/2) / infaredImgWidth);
    PVector right = new PVector(4500, 0, 0);    
    PVector vu = new PVector(0, 4500, 0);
    PVector vd = new PVector(0, 0, -4500);

    far_0 = new PVector(0, 0, 0);
    far_0.x += vd.x - right.x*tan(thetah/2) - vu.x*tan(thetav/2);
    far_0.y += vd.y - right.y*tan(thetah/2) - vu.y*tan(thetav/2);
    far_0.z += vd.z - right.z*tan(thetah/2) - vu.z*tan(thetav/2);

    far_1 = new PVector(0, 0, 0);
    far_1.x += vd.x + right.x*tan(thetah/2) - vu.x*tan(thetav/2);
    far_1.y += vd.y + right.y*tan(thetah/2) - vu.y*tan(thetav/2);
    far_1.z += vd.z + right.z*tan(thetah/2) - vu.z*tan(thetav/2);

    far_2 = new PVector(0, 0, 0);
    far_2.x += vd.x + right.x*tan(thetah/2) + vu.x*tan(thetav/2);
    far_2.y += vd.y + right.y*tan(thetah/2) + vu.y*tan(thetav/2);
    far_2.z += vd.z + right.z*tan(thetah/2) + vu.z*tan(thetav/2);

    far_3 = new PVector(0, 0, 0);
    far_3.x += vd.x - right.x*tan(thetah/2) + vu.x*tan(thetav/2);
    far_3.y += vd.y - right.y*tan(thetah/2) + vu.y*tan(thetav/2);
    far_3.z += vd.z - right.z*tan(thetah/2) + vu.z*tan(thetav/2);

    near_0 = far_0.copy().normalize().mult(500);
    near_1 = far_1.copy().normalize().mult(500);
    near_2 = far_2.copy().normalize().mult(500);
    near_3 = far_3.copy().normalize().mult(500);
  }
  //---------------------
  // COMPUTATION METHODS
  //---------------------
  public void computePinholeCamaraModel()
  {
    rawDepthData = getRawDepthData();
    for (int i=0; i<newDepthWidth; i++)
    {
      for (int j=0; j<newDepthHeight; j++)
      {
        //2D depth Coord
        PVector pixelDepthCoord = new PVector(i * gridResolution, j * gridResolution);
        int index = (int) pixelDepthCoord.x + (int) pixelDepthCoord.y * infaredImgWidth;
        int depth = rawDepthData[index];

        computeDepth3DCoord(i, j, pixelDepthCoord, depth);
        computeColor3DCoord(i, j, depth3DCoord[i][j]);
        computeColor2DCoord(i, j, color3DCoord[i][j]);
      }
    }
  }

  public void computePinholeCamaraModelonBodyTrack()
  {
    rawDepthData = getRawDepthData();
    rawBodyTrackData = getRawBodyTrackData();

    for (int i=0; i<newDepthWidth; i++)
    {
      for (int j=0; j<newDepthHeight; j++)
      {
        //2D depth Coord
        PVector pixelDepthCoord = new PVector(i * gridResolution, j * gridResolution);
        int index = (int) pixelDepthCoord.x + (int) pixelDepthCoord.y * infaredImgWidth;
        int depth = 0;

        if (rawBodyTrackData[index] != 255)
        {
          //2D Depth Coord
          depth = rawDepthData[index];
        } else
        {
        }

        computeDepth3DCoord(i, j, pixelDepthCoord, depth);
        computeColor3DCoord(i, j, depth3DCoord[i][j]);
        computeColor2DCoord(i, j, color3DCoord[i][j]);
      }
    }
  }

  public void computeDepth3DCoord(int i, int j, PVector pixelDepthCoord, float depth)
  {
    //3D Depth Coord - Back projecting pixel depth coord to 3D depth coord
    float bppx = (pixelDepthCoord.x - (float) c_x) * depth / (float) f_x;
    float bppy = (pixelDepthCoord.y - (float) c_y) * depth / (float) f_y;
    float bppz = -depth;

    depth3DCoord[i][j] = new PVector(bppx, bppy, bppz);
  }

  public void computeColor3DCoord(int i, int j, PVector pixel3DDepthCoord)
  {
    if (pixel3DDepthCoord != null)
    {
      //transpose 3D depth coord to 3D color coord
      double x_ = (pixel3DDepthCoord.x * R[0] + pixel3DDepthCoord.y * R[1] + pixel3DDepthCoord.z * R[2]) + T[0];
      double y_ = (pixel3DDepthCoord.x * R[3] + pixel3DDepthCoord.y * R[4] + pixel3DDepthCoord.z * R[5]) + T[1];
      double z_ = (pixel3DDepthCoord.x * R[6] + pixel3DDepthCoord.y * R[7] + pixel3DDepthCoord.z * R[8]) + T[2];

      color3DCoord[i][j] = new PVector((float) x_, (float) y_, (float) z_);
    } else
    {
      println("pixel3DDepthCoord == null");
    }
  }

  public void computeColor2DCoord(int i, int j, PVector pixel3DColorCoord)
  {
    if (pixel3DColorCoord != null)
    {
      //Project 3D color coord to 2D color Cood
      double pcx = (pixel3DColorCoord.x * f_x_R / pixel3DColorCoord.z) + c_x_R;
      double pcy = (pixel3DColorCoord.y * f_y_R / pixel3DColorCoord.z) + c_y_R;

      color2DCoord[i][j] = new PVector((float) pcx * -1 + colorImgWidth/2, (float) pcy * -1 + colorImgHeight/2);
    } else
    {
      println("pixel3DColorCoord == null");
    }
  }

  public void compute2DDepthNormalizeSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = norm(joints[j].getX(), 0, infaredImgWidth);
          float jointY = norm(joints[j].getY(), 0, infaredImgHeight);
          float jointZ = norm(joints[j].getZ(), 0, 4500);

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  public void compute2DDepthSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = joints[j].getX();
          float jointY = joints[j].getY();
          float jointZ = joints[j].getZ();

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  public void compute2DColorNormalizeSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = norm(joints[j].getX(), 0, infaredImgWidth);
          float jointY = norm(joints[j].getY(), 0, infaredImgHeight);
          float jointZ = norm(joints[j].getZ(), 0, 4500);

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  public void compute2DColorSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = joints[j].getX();
          float jointY = joints[j].getY();
          float jointZ = joints[j].getZ();

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  public void compute3DSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = joints[j].getX() * 1000;
          float jointY = joints[j].getY() * 1000;
          float jointZ = joints[j].getZ() * 1000;

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  public void compute3DNormalizeSkeleton()
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        for (int j=0; j<skeletonList.size(); j++)
        {
          float jointX = joints[j].getX();
          float jointY = joints[j].getY();
          float jointZ = joints[j].getZ();

          skeletonList.set(j, new PVector(jointX, jointY, jointZ));
        }

        for (int j=0; j<skeletonStateList.size(); j++)
        {
          skeletonStateList.set(j, joints[j].getState());
        }
      }
    }
  }

  //---------------------
  // DISPLAY METHODS
  //---------------------
  public void directDisplayDepth3DData()
  {
    beginShape(POINTS);
    for (int i = 0; i < newDepthWidth; i++) {
      for (int j = 0; j < newDepthHeight; j++) {
        PVector v = depth3DCoord[i][j];   
        float n = 0.75 - norm(v.z, 0, -4500);
        PVector nv = v.copy().normalize();

        stroke(nv.x * 255, nv.y * 255, nv.z * -1 * 255);
        vertex(v.x, v.y, v.z);
      }
    }
    endShape();
  }

  public void directDisplayColor3DData()
  {
    beginShape(POINTS);
    for (int i = 0; i < newDepthWidth; i++) {
      for (int j = 0; j < newDepthHeight; j++) {
        PVector v = color3DCoord[i][j];   
        float n = 0.75 - norm(v.z, 0, -4500);
        PVector nv = v.copy().normalize();

        stroke(nv.x * 255, nv.y * 255, nv.z * -1 * 255);
        vertex(v.x, v.y, v.z);
      }
    }
    endShape();
  }

  public void directDisplayColor2DData()
  {
    beginShape(POINTS);
    for (int i = 0; i < newDepthWidth; i++) {
      for (int j = 0; j < newDepthHeight; j++) {
        PVector v = color2DCoord[i][j];   
        float n = 0.75 - norm(v.z, 0, -4500);
        PVector nv = v.copy().normalize();

        stroke(nv.x * 255, nv.y * 255, 255);
        vertex(v.x, v.y);
      }
    }
    endShape();
  }

  public void directDisplay3DDepthShape()
  {
    beginShape(TRIANGLES);
    noStroke();
    for (int i = 0; i < newDepthWidth-1; i++) {
      for (int j = 0; j < newDepthHeight-1; j++) {
        //define index
        int ii00 = i;
        int ii01 = i+1;
        int ij00 = j;
        int ij01 = j+1;

        //get vertex & depth
        PVector vert0 = depth3DCoord[ii00][ij00];
        PVector vert1 = depth3DCoord[ii01][ij00];
        PVector vert2 = depth3DCoord[ii00][ij01];
        PVector vert3 = depth3DCoord[ii01][ij01];

        //check if off limit
        if (vert0.z < near_0.z && vert1.z < near_1.z && vert2.z < near_2.z && vert3.z < near_3.z)
        {
          //get compute uv

          float uvx0 = norm(vert0.x, -1920/2, 1920/2) + 0.01;
          float uvy0 = norm(vert0.y, -1080/2, 1080/2) + 0.01;
          float uvx1 = norm(vert1.x, -1920/2, 1920/2) + 0.01;
          float uvy1 = norm(vert1.y, -1080/2, 1080/2) + 0.01;
          float uvx2 = norm(vert2.x, -1920/2, 1920/2) + 0.01;
          float uvy2 = norm(vert2.y, -1080/2, 1080/2) + 0.01;
          float uvx3 = norm(vert3.x, -1920/2, 1920/2) + 0.01;
          float uvy3 = norm(vert3.y, -1080/2, 1080/2) + 0.01;
          /*
          //draw Quads
           //triangle 00
           vertex(vert0.x, vert0.y, vert0.z, uvx0, uvy0);
           vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
           vertex(vert3.x, vert3.y, vert3.z, uvx3, uvy3);
           vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
           
           */
          //draw triangleShape
          //triangle 00
          vertex(vert0.x, vert0.y, vert0.z, uvx0, uvy0);
          vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
          vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
          //triangle 01
          vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
          vertex(vert3.x, vert3.y, vert3.z, uvx3, uvy3);
          vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
        } else
        {
          //println(i, j, vert0, vert1, vert2, vert3);
        }
      }
    }
    endShape(CLOSE);
  }

  public void directDisplay3DColorShape()
  { 
    PImage textureColor = getColorImg();
    textureColor.loadPixels();

    beginShape(TRIANGLES);
    noStroke();
    noFill();
    texture(textureColor);
    textureMode(NORMAL);

    for (int i = 0; i < newDepthWidth-1; i++) {
      for (int j = 0; j < newDepthHeight-1; j++) {
        //define index
        int ii00 = i;
        int ii01 = i+1;
        int ij00 = j;
        int ij01 = j+1;

        //get vertex & depth
        PVector vert0 = color3DCoord[ii00][ij00];
        PVector vert1 = color3DCoord[ii01][ij00];
        PVector vert2 = color3DCoord[ii00][ij01];
        PVector vert3 = color3DCoord[ii01][ij01];

        PVector vert0_2D = color2DCoord[ii00][ij00];
        PVector vert1_2D = color2DCoord[ii01][ij00];
        PVector vert2_2D = color2DCoord[ii00][ij01];
        PVector vert3_2D = color2DCoord[ii01][ij01];



        //check if off limit
        if (vert0.z < near_0.z && vert1.z < near_1.z && vert2.z < near_2.z && vert3.z < near_3.z)
        {
          //get compute uv

          float uvx0 = norm(vert0_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy0 = norm(vert0_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx1 = norm(vert1_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy1 = norm(vert1_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx2 = norm(vert2_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy2 = norm(vert2_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx3 = norm(vert3_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy3 = norm(vert3_2D.y, -1080/2, 1080/2) + 0.01;
          /*
          //draw Quads
           //triangle 00
           vertex(vert0.x, vert0.y, vert0.z, uvx0, uvy0);
           vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
           vertex(vert3.x, vert3.y, vert3.z, uvx3, uvy3);
           vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
           
           */
          //draw triangleShape
          //triangle 00
          vertex(vert0.x, vert0.y, vert0.z, uvx0, uvy0);
          vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
          vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
          //triangle 01
          vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
          vertex(vert3.x, vert3.y, vert3.z, uvx3, uvy3);
          vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
        } else
        {
          //println(i, j, vert0, vert1, vert2, vert3);
        }
      }
    }
    endShape(CLOSE);
  }

  public void directDisplay2DColorShape()
  {
    PImage textureColor = getColorImg();
    textureColor.loadPixels();

    beginShape(TRIANGLES);
    noStroke();
    noFill();
    texture(textureColor);
    textureMode(NORMAL);

    for (int i = 0; i < newDepthWidth-1; i++) {
      for (int j = 0; j < newDepthHeight-1; j++) {
        //define index
        int ii00 = i;
        int ii01 = i+1;
        int ij00 = j;
        int ij01 = j+1;

        //get vertex & depth

        PVector vert0 = color3DCoord[ii00][ij00];
        PVector vert1 = color3DCoord[ii01][ij00];
        PVector vert2 = color3DCoord[ii00][ij01];
        PVector vert3 = color3DCoord[ii01][ij01];

        PVector vert0_2D = color2DCoord[ii00][ij00];
        PVector vert1_2D = color2DCoord[ii01][ij00];
        PVector vert2_2D = color2DCoord[ii00][ij01];
        PVector vert3_2D = color2DCoord[ii01][ij01];



        //check if off limit
        if (vert0.z < near_0.z && vert1.z < near_1.z && vert2.z < near_2.z && vert3.z < near_3.z)
        {
          //get compute uv

          float uvx0 = norm(vert0_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy0 = norm(vert0_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx1 = norm(vert1_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy1 = norm(vert1_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx2 = norm(vert2_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy2 = norm(vert2_2D.y, -1080/2, 1080/2) + 0.01;
          float uvx3 = norm(vert3_2D.x, -1920/2, 1920/2) + 0.01;
          float uvy3 = norm(vert3_2D.y, -1080/2, 1080/2) + 0.01;
          /*
          //draw Quads
           //triangle 00
           vertex(vert0.x, vert0.y, vert0.z, uvx0, uvy0);
           vertex(vert1.x, vert1.y, vert1.z, uvx1, uvy1);
           vertex(vert3.x, vert3.y, vert3.z, uvx3, uvy3);
           vertex(vert2.x, vert2.y, vert2.z, uvx2, uvy2);
           
           */
          //draw triangleShape
          //triangle 00
          vertex(vert0_2D.x, vert0_2D.y, uvx0, uvy0);
          vertex(vert1_2D.x, vert1_2D.y, uvx1, uvy1);
          vertex(vert2_2D.x, vert2_2D.y, uvx2, uvy2);
          //triangle 01
          vertex(vert1_2D.x, vert1_2D.y, uvx1, uvy1);
          vertex(vert3_2D.x, vert3_2D.y, uvx3, uvy3);
          vertex(vert2_2D.x, vert2_2D.y, uvx2, uvy2);
        } else
        {
          //println(i, j, vert0, vert1, vert2, vert3);
        }
      }
    }
    endShape(CLOSE);
  }

  public void directDisplayFrustum()
  {
    pushStyle();
    noFill();
    stroke(255, 255, 0);
    line(0, 0, 0, far_0.x, far_0.y, far_0.z);
    line(0, 0, 0, far_1.x, far_1.y, far_1.z);
    line(0, 0, 0, far_2.x, far_2.y, far_2.z);
    line(0, 0, 0, far_3.x, far_3.y, far_3.z);

    beginShape(QUAD);
    vertex(far_0.x, far_0.y, far_0.z);
    vertex(far_1.x, far_1.y, far_1.z);
    vertex(near_1.x, near_1.y, near_1.z);
    vertex(near_0.x, near_0.y, near_0.z);

    vertex(far_1.x, far_1.y, far_1.z);
    vertex(far_2.x, far_2.y, far_2.z);
    vertex(near_2.x, near_2.y, near_2.z);
    vertex(near_1.x, near_1.y, near_1.z);

    vertex(far_2.x, far_2.y, far_2.z);
    vertex(far_3.x, far_3.y, far_3.z);
    vertex(near_3.x, near_3.y, near_3.z);
    vertex(near_2.x, near_2.y, near_2.z);

    vertex(far_3.x, far_3.y, far_3.z);
    vertex(far_0.x, far_0.y, far_0.z);
    vertex(near_0.x, near_0.y, near_0.z);
    vertex(near_3.x, near_3.y, near_3.z);
    endShape();

    popStyle();
  }

  public void display2DDepthSkeleton(float x_, float y_, float w_, float r_)
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
    pushStyle();
    pushMatrix();
    translate(x_, y_);
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        color col  = skeleton.getIndexColor();
        fill(col);
        stroke(col);

        //debug Direct Display
        draw2DBody(joints, w_, r_, infaredImgWidth, infaredImgHeight);
        draw2DHandState(joints[KinectPV2.JointType_HandRight], w_, r_, infaredImgWidth, infaredImgHeight);
        draw2DHandState(joints[KinectPV2.JointType_HandLeft], w_, r_, infaredImgWidth, infaredImgHeight);
      }
    }
    popMatrix();
    popStyle();
  }

  public void display2DColorSkeleton(float x_, float y_, float w_, float r_)
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
    pushStyle();
    pushMatrix();
    translate(x_, y_);
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        color col  = skeleton.getIndexColor();
        fill(col);
        stroke(col);

        //debug Direct Display
        draw2DBody(joints, w_, r_, colorImgWidth, colorImgHeight);
        draw2DHandState(joints[KinectPV2.JointType_HandRight], w_, r_, colorImgWidth, colorImgHeight);
        draw2DHandState(joints[KinectPV2.JointType_HandLeft], w_, r_, colorImgWidth, colorImgHeight);
      }
    }
    popMatrix();
    popStyle();
  }

  public void display3DSkeleton(float r_)
  {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    pushStyle();

    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      //if the skeleton is being tracked compute the skleton joints
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        color col  = skeleton.getIndexColor();
        fill(col);
        stroke(col);

        //debug Direct Display
        draw3DBody(joints, r_);
        draw3DHandState(joints[KinectPV2.JointType_HandRight], r_);
        draw3DHandState(joints[KinectPV2.JointType_HandLeft], r_);
      }
    }
    popStyle();
  }

  //draw the body
  public void draw2DBody(KJoint[] joints, float w_, float r_, float ow_, float oh_) {
    draw2DBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft, w_, r_, ow_, oh_);

    // Right Arm
    draw2DBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight, w_, r_, ow_, oh_);

    // Left Arm
    draw2DBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft, w_, r_, ow_, oh_);

    // Right Leg
    draw2DBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight, w_, r_, ow_, oh_);

    // Left Leg
    draw2DBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft, w_, r_, ow_, oh_);
    draw2DBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft, w_, r_, ow_, oh_);

    //Single joints
    draw2DJoint(joints, KinectPV2.JointType_HandTipLeft, w_, r_, ow_, oh_);
    draw2DJoint(joints, KinectPV2.JointType_HandTipRight, w_, r_, ow_, oh_);
    draw2DJoint(joints, KinectPV2.JointType_FootLeft, w_, r_, ow_, oh_);
    draw2DJoint(joints, KinectPV2.JointType_FootRight, w_, r_, ow_, oh_);

    draw2DJoint(joints, KinectPV2.JointType_ThumbLeft, w_, r_, ow_, oh_);
    draw2DJoint(joints, KinectPV2.JointType_ThumbRight, w_, r_, ow_, oh_);

    draw2DJoint(joints, KinectPV2.JointType_Head, w_, r_, ow_, oh_);
  }

  public void draw3DBody(KJoint[] joints, float r_) {
    draw3DBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck, r_);
    draw3DBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight, r_);
    draw3DBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft, r_);

    // Right Arm
    draw3DBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight, r_);
    draw3DBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight, r_);
    draw3DBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight, r_);
    draw3DBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight, r_);
    draw3DBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight, r_);

    // Left Arm
    draw3DBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft, r_);

    // Right Leg
    draw3DBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight, r_);
    draw3DBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight, r_);
    draw3DBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight, r_);

    // Left Leg
    draw3DBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft, r_);
    draw3DBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft, r_);

    //Single joints
    draw3DJoint(joints, KinectPV2.JointType_HandTipLeft, r_);
    draw3DJoint(joints, KinectPV2.JointType_HandTipRight, r_);
    draw3DJoint(joints, KinectPV2.JointType_FootLeft, r_);
    draw3DJoint(joints, KinectPV2.JointType_FootRight, r_);

    draw3DJoint(joints, KinectPV2.JointType_ThumbLeft, r_);
    draw3DJoint(joints, KinectPV2.JointType_ThumbRight, r_);

    draw3DJoint(joints, KinectPV2.JointType_Head, r_);
  }

  //draw a single joint
  public void draw2DJoint(KJoint[] joints, int jointType, float w_, float r_, float ow_, float oh_) {
    float jointX = norm(joints[jointType].getX(), 0, ow_) * w_;
    float jointY = norm(joints[jointType].getY(), 0, oh_) * (w_ / r_);
    float jointScale =  25 / (r_*4);
    if (joints[jointType].getState() == 2 )
    {
      pushMatrix();
      translate(jointX, jointY, 0);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
    }
  }

  public void draw3DJoint(KJoint[] joints, int jointType, float r_) {
    float jointX = joints[jointType].getX() * 1000;
    float jointY = joints[jointType].getY() * 1000 * -1;
    float jointZ = joints[jointType].getZ() * -1000;
    float jointScale =  25 / (r_*4);
    if (joints[jointType].getState() == 2 )
    {
      pushMatrix();
      translate(jointX, jointY, jointZ);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
    }
  }

  //draw a bone from two joints
  public void draw2DBone(KJoint[] joints, int jointType1, int jointType2, float w_, float r_, float ow_, float oh_) {
    float joint1X = norm(joints[jointType1].getX(), 0, ow_) *  w_;
    float joint1Y = norm(joints[jointType1].getY(), 0, oh_) * (w_ / r_);
    float joint2X = norm(joints[jointType2].getX(), 0, ow_) * w_;
    float joint2Y = norm(joints[jointType2].getY(), 0, oh_) * (w_ / r_);
    float jointScale = 25 / (r_*4);
    if (joints[jointType1].getState() == 2 && joints[jointType2].getState() == 2)
    {
      pushMatrix();
      translate(joint1X, joint1Y, 0);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
      line(joint1X, joint1Y, 0, joint2X, joint2Y, 0);
    }
  }

  public void draw3DBone(KJoint[] joints, int jointType1, int jointType2, float r_) {
    float joint1X = joints[jointType1].getX() * 1000;
    float joint1Y = joints[jointType1].getY() * 1000 * -1;
    float joint1Z = joints[jointType1].getZ() * -1000;
    float joint2X = joints[jointType2].getX() * 1000;
    float joint2Y = joints[jointType2].getY() * 1000 * -1;
    float joint2Z = joints[jointType2].getZ() * -1000;
    float jointScale = 25 / (r_*4);
    if (joints[jointType1].getState() == 2 && joints[jointType2].getState() == 2)
    {
      pushMatrix();
      translate(joint1X, joint1Y, joint1Z);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
      line(joint1X, joint1Y, joint1Z, joint2X, joint2Y, joint2Z);
    }
  }

  //draw a ellipse depending on the hand state
  public void draw2DHandState(KJoint joint, float w_, float r_, float ow_, float oh_) {
    float jointX = norm(joint.getX(), 0, ow_) * w_;
    float jointY = norm(joint.getY(), 0, oh_) * (w_ / r_);
    float jointScale = 25 / r_;
    if (joint.getState() == 2 )
    {
      noFill();
      handState(joint.getState());
      pushMatrix();
      translate(jointX, jointY, 0);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
    }
  }

  public void draw3DHandState(KJoint joint, float r_) {
    float jointX = joint.getX() * 1000;
    float jointY = joint.getY() * 1000 * -1;
    float jointZ = joint.getZ() * -1000;
    float jointScale = 25 / r_;
    if (joint.getState() == 2 )
    {
      noFill();
      handState(joint.getState());
      pushMatrix();
      translate(jointX, jointY, jointZ);
      ellipse(0, 0, jointScale, jointScale);
      popMatrix();
    }
  }

  //Depending on the hand state change the color
  public void handState(int handState) {
    switch(handState) {
    case KinectPV2.HandState_Open:
      stroke(0, 255, 0);
      break;
    case KinectPV2.HandState_Closed:
      stroke(255, 0, 0);
      break;
    case KinectPV2.HandState_Lasso:
      stroke(0, 0, 255);
      break;
    case KinectPV2.HandState_NotTracked:
      stroke(100, 100, 100);
      break;
    }
  }

  //---------------------
  // DEBUG METHODS
  //---------------------
  public void showDebug()
  {
    showDebug(0, 0, 0.25);
  }

  public void showDebug(float x_, float y_, float s_)
  {
    float ncw = colorImgWidth * s_;
    float nch = colorImgHeight * s_;
    float ndw = ncw / 2;
    float ndh = ndw / infaredRatio;
    float g3w = (ndw*2) / 3;
    float g3h = g3w / infaredRatio;

    pushStyle();
    image(getColorImg(), x_, y_, ncw, nch);
    image(getDepthImg(), x_, y_ + nch, ndw, ndh);
    image(getDepth256Img(), x_ + ndw, y_ + nch, ndw, ndh);
    image(getInfaredImg(), x_, y_ + nch + ndh, g3w, g3h);
    image(getLongExposureInfaredImg(), x_ + g3w, y_ + nch + ndh, g3w, g3h);    
    image(getBodyTrackImg(), x_ + g3w * 2, y_ + nch + ndh, g3w, g3h);
    popStyle();
  }

  //---------------------
  // SET METHODS
  //---------------------
  public void setMinDist(int minDist_)
  {
    minThreshold = minDist_;
    kinect.setLowThresholdPC(minThreshold);
  }

  public void setMaxDist(int maxDist_)
  {
    maxThreshold = maxDist_;
    kinect.setHighThresholdPC(maxThreshold);
  }

  public void setGridResolution(int offset_)
  {
    gridResolution = offset_;
    initCoordinatesArrays(gridResolution);
  }

  //---------------------
  // GET METHODS
  //---------------------
  public void printSkeletonIndices()
  {
    println("KinectPV2.JointType_Head : "+KinectPV2.JointType_Head);
    println("KinectPV2.JointType_Neck : "+KinectPV2.JointType_Neck);
    println("KinectPV2.JointType_SpineShoulder : "+KinectPV2.JointType_SpineShoulder);
    println("KinectPV2.JointType_SpineMid : "+KinectPV2.JointType_SpineMid);
    println("KinectPV2.JointType_ShoulderRight : "+KinectPV2.JointType_ShoulderRight);
    println("KinectPV2.JointType_ShoulderLeft : "+KinectPV2.JointType_ShoulderLeft);
    println("KinectPV2.JointType_SpineBase : "+KinectPV2.JointType_SpineBase);
    println("KinectPV2.JointType_HipRight : "+KinectPV2.JointType_HipRight);
    println("KinectPV2.JointType_HipLeft : "+KinectPV2.JointType_HipLeft);

    // Right Arm
    println("KinectPV2.JointType_ElbowRight : "+KinectPV2.JointType_ElbowRight);
    println("KinectPV2.JointType_WristRight : "+KinectPV2.JointType_WristRight);
    println("KinectPV2.JointType_HandRight : "+KinectPV2.JointType_HandRight);
    println("KinectPV2.JointType_HandTipRight : "+KinectPV2.JointType_HandTipRight);
    println("KinectPV2.JointType_ThumbRight : "+KinectPV2.JointType_ThumbRight);

    // Left Arm
    println("KinectPV2.JointType_ElbowLeft : "+KinectPV2.JointType_ElbowLeft);
    println("KinectPV2.JointType_WristLeft : "+KinectPV2.JointType_WristLeft);
    println("KinectPV2.JointType_HandLeft : "+KinectPV2.JointType_HandLeft);
    println("KinectPV2.JointType_HandTipLeft : "+KinectPV2.JointType_HandTipLeft);
    println("KinectPV2.JointType_ThumbLeft : "+KinectPV2.JointType_ThumbLeft);

    // Right Leg
    println("KinectPV2.JointType_KneeRight : "+KinectPV2.JointType_KneeRight);
    println("KinectPV2.JointType_AnkleRight : "+KinectPV2.JointType_AnkleRight);
    println("KinectPV2.JointType_FootRight : "+KinectPV2.JointType_FootRight);

    // Left Leg
    println("KinectPV2.JointType_KneeLeft : "+KinectPV2.JointType_KneeLeft);
    println("KinectPV2.JointType_AnkleLeft : "+KinectPV2.JointType_AnkleLeft);
    println("KinectPV2.JointType_FootLeft : "+KinectPV2.JointType_FootLeft);
  }

  public int getMinDist()
  {
    return minThreshold;
  }

  public int getMaxDist()
  {
    return maxThreshold;
  }

  public int getColorWidth()
  {
    return colorImgWidth;
  }

  public int getColorHeight()
  {
    return colorImgHeight;
  }

  public float getColorRatio()
  {
    return colorRatio;
  }

  public int getInfaredWidth()
  {
    return infaredImgWidth;
  }

  public int getInfaredHeight()
  {
    return infaredImgHeight;
  }

  public float getInfaredRatio()
  {
    return infaredRatio;
  }

  public PImage getColorImg()
  {
    return kinect.getColorImage();
  }

  public PImage getDepthImg()
  {
    return kinect.getDepthImage();
  }

  public PImage getDepth256Img()
  {
    return kinect.getDepth256Image();
  }

  public PImage getBodyTrackImg()
  {
    return kinect.getBodyTrackImage();
  }

  public PImage getInfaredImg()
  {
    return kinect.getInfraredImage();
  }

  public PImage getLongExposureInfaredImg()
  {
    return kinect.getInfraredLongExposureImage();
  }

  public int[] getRawDepthData()
  {
    rawDepthData = kinect.getRawDepthData();
    return rawDepthData;
  }

  public int[] getRawBodyTrackData()
  {
    rawBodyTrackData = kinect.getRawBodyTrack();
    return rawBodyTrackData;
  }

  public int getGridResolution()
  {
    return gridResolution;
  }

  public PVector[][] getDepth3DCoord()
  {
    return depth3DCoord;
  }

  public PVector[][] getColor3DCoord()
  {
    return color3DCoord;
  }

  public PVector[][] getColor2DCoord()
  {
    return color2DCoord;
  }

  public PVector[] getNearPlane()
  {
    PVector[] nearPlane = {
      near_0.copy(), 
      near_1.copy(), 
      near_2.copy(), 
      near_3.copy()
    };
    return nearPlane;
  }
}


/*Skeleton Indices :
 KinectPV2.JointType_Head : 3
 KinectPV2.JointType_Neck : 2
 KinectPV2.JointType_SpineShoulder : 20
 KinectPV2.JointType_SpineMid : 1
 KinectPV2.JointType_ShoulderRight : 8
 KinectPV2.JointType_ShoulderLeft : 4
 KinectPV2.JointType_SpineBase : 0
 KinectPV2.JointType_HipRight : 16
 KinectPV2.JointType_HipLeft : 12
 KinectPV2.JointType_ElbowRight : 9
 KinectPV2.JointType_WristRight : 10
 KinectPV2.JointType_HandRight : 11
 KinectPV2.JointType_HandTipRight : 23
 KinectPV2.JointType_ThumbRight : 24
 KinectPV2.JointType_ElbowLeft : 5
 KinectPV2.JointType_WristLeft : 6
 KinectPV2.JointType_HandLeft : 7
 KinectPV2.JointType_HandTipLeft : 21
 KinectPV2.JointType_ThumbLeft : 22
 KinectPV2.JointType_KneeRight : 17
 KinectPV2.JointType_AnkleRight : 18
 KinectPV2.JointType_FootRight : 19
 KinectPV2.JointType_KneeLeft : 13
 KinectPV2.JointType_AnkleLeft : 14
 KinectPV2.JointType_FootLeft : 15
 */

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */