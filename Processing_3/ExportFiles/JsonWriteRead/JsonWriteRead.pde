String[] name = { 
  "Capra hircus", "Panthera pardus", "Equus zebra"
};

float[] floatelement = {
  0.1, 2.5, 3.5
};

JSONArray jsonArray, jsonFile;
boolean load;

void setup() {

  jsonArray = new JSONArray();

  for (int i = 0; i < name.length; i++) {

    JSONObject jsonObj = new JSONObject();

    jsonObj.setInt("id", i);
    jsonObj.setString("name", name[i]);
    jsonObj.setFloat("floatelement", floatelement[i]);

    jsonArray.setJSONObject(i, jsonObj);
  }

  saveJSONArray(jsonArray, "data/new.json");
}

void draw()
{
  if (!load)
  {
    jsonFile = loadJSONArray("new.json");
    println(jsonFile.size ());
    // Get the first array of elements
    /*JSONArray values1 = json.getJSONArray(0);*/

    for (int i = 0; i < jsonFile.size (); i++) {

      JSONObject item = jsonFile.getJSONObject(i); 


      println(item);
    }
    load = true;
  }
}