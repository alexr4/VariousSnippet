//Convert icosahedron with GLModel in order to texture it
GLModel createIcosahedron(Icosahedron ico) {


  GLModel mesh = new GLModel(this, ico.positions.size(), TRIANGLES, GLModel.DYNAMIC);


  // positions
  mesh.updateVertices(ico.positions);

  // Sets the normals.
  mesh.initNormals();
  mesh.updateNormals(ico.normals);



  // texCoords + textures   
  /*
  mesh.initTextures(1);
   mesh.setTexture(0, os.offscreenDisp.getTexture());
   mesh.updateTexCoords(0, ico.texCoords);
   */

  //color
  mesh.initColors();
  mesh.beginUpdateColors();
  for (int i=0; i<ico.positions.size(); i++)
  {
    PVector a = ico.positions.get(i).get();
    float limiteB = -ico.r;
    float limiteH = ico.r;
    
    float r = map(a.x, limiteB, limiteH, 0, 50);
    float g = map(a.y, limiteB, limiteH, 0, 50);
    float b = map(a.z, limiteB, limiteH, 0, 50);
    mesh.updateColor(i, r, g, b, 255);
  }
  mesh.endUpdateColors();


  return mesh;
}

