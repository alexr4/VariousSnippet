String path = "C:/Users/Alex/Desktop/Processing-301-snippets/ExportFiles/archiveJSON/data/silhouette/";
String savedPath = "C:/Users/Alex/Desktop/Processing-301-snippets/ExportFiles/archiveJSON/data/saved";
String date = year()+""+nf(month(), 2)+""+day();

void setup()
{
  listAllFolders(path, date, savedPath);
}