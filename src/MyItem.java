public class MyItem{
	public String name, type, value, currentScope;
	public String []names = new String[2];
    	public MyItem(String inname,String intype,String invalue,String inscope) {
    	name = inname;
    	type = intype;
    	value = invalue;
    	currentScope = inscope;
    	names = inname.split(" ");
    	
    }
}

