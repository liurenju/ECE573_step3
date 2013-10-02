import org.antlr.runtime.*;

public class Micro{
  public static void main(String []args) throws Exception{
    MicroLexer lex = new MicroLexer(new ANTLRFileStream(args[0]));
    CommonTokenStream t = new CommonTokenStream(lex);
    MicroParser parser = new MicroParser(t);
    
    try{
      parser.program();
      //System.out.println("Accepted");
    } catch (RecognitionException e){
    }
  }
  
}
