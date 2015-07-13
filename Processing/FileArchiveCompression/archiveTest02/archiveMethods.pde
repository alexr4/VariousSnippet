import java.util.zip.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

void createArchive(String path, String date, String[] fileList, String newPath)
{
  // Input files
  FileInputStream in = null;
  // Output file
  ZipOutputStream out = null;
  try
  {
    out = new ZipOutputStream(new FileOutputStream(newPath+date+".zip"));
    for (String file : fileList)
    {
      File directory = new File(path+file);
      if (directory.exists()) {
        File[] files = directory.listFiles();
        if (null!= files) {
          String[] fileNameList = new String[files.length];
          for (int i=0; i<files.length; i++) {
            String fileName = files[i].getName().toString();
            fileNameList[i] = fileName;

            in = new FileInputStream(path + file + "/" + fileName);
            // Name the file inside the zip file
            out.putNextEntry(new ZipEntry(file+"_"+fileName));
            byte[] b = new byte[1024];
            int count;
            while ( (count = in.read (b)) > 0)
            {
              out.write(b, 0, count);
            }
            in.close();
          }
        }
      }
    }
  }
  catch (IOException e)
  {
    e.printStackTrace();
  }
  finally
  {
    try
    {
      if (out != null) out.close();
      if (in != null) in.close();
      for (String file : fileList)
      {
        File directory = new File(path+file);
        deleteDirectory(directory);
      }
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }
  println("Archive created");
  //exit();
}

public void deleteDirectory(File directory) {
  if (directory.exists()) {
    File[] files = directory.listFiles();
    if (null!=files) {
      for (int i=0; i<files.length; i++) {
        if (files[i].isDirectory()) {
          deleteDirectory(files[i]);
        } else {
          files[i].delete();
        }
      }
    }
  }
  directory.delete();
}

public void listAllFolders(String path, String date, String newPath)
{
  File directory = new File(path);
  if (directory.exists()) {
    File[] files = directory.listFiles();
    if (null!= files) {
      String[] fileNameList = new String[files.length];
      for (int i=0; i<files.length; i++) {
        String fileName = files[i].getName().toString();
        fileNameList[i] = fileName;
      }

      createArchive(path, date, fileNameList, newPath);
    }
  }
}

