import java.util.zip.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

String path = "C:/Users/rivaux/Desktop/archiveTest02/data/silhouette/";
String savedPath = "C:/Users/rivaux/Desktop/archiveTest02/data/saved/";
String date = year()+""+nf(month(), 2)+""+day();

void setup()
{
  listAllFolders(path, date, savedPath);
}

