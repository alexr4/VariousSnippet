import java.util.zip.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

String path = "C:/Users/rivaux/Desktop/archiveTest/data/silhouette/";
String date = "20150713";
String slash = "/";
String[] files = { 
  date+slash+"silhouette_000000.json", date+slash+"silhouette_000001.json", date+slash+"silhouette_000002.json"
};

void setup()
{
  // Input files
  FileInputStream in = null;
  // Output file
  ZipOutputStream out = null;
  try
  {
    out = new ZipOutputStream(new FileOutputStream(path+date+".zip"));
    for (String file : files)
    {
      in = new FileInputStream(path + file);
      // Name the file inside the zip file
      out.putNextEntry(new ZipEntry(file));
      byte[] b = new byte[1024];
      int count;
      while ( (count = in.read (b)) > 0)
      {
        out.write(b, 0, count);
      }
      in.close();
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
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }
  println("Archive created");
  exit();
}

