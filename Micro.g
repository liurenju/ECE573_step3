grammar Micro;


/*KEYWORD	:	'PROGRAM'|'BEGIN'|'END'|'FUNCTION'|
		'READ'|'WRITE'|'IF'|'ELSIF'|'ENDIF'|'DO'|'WHILE'|'CONTINUE'|'BREAK'|
		'RETURN'|'INT'|'VOID'|'STRING'|'FLOAT'|'TRUE'|'FALSE';

		
OPERATOR:	')'|':='|'+'|'-'|'*'|'/'|'='|'!='|'<'|'>'|'('|';'|','|'<='|'>=';*/


@members {
ArrayList<MyItem> symbols = new ArrayList<MyItem>(1000);
ArrayList<String> shadow = new ArrayList<String>();

int intorfloat;
int blockn = 0;
boolean global = false;
MyItem item;
boolean funcTable = false;
String tableName = "";

}

COMMENT	:	    '--'~('\n')+{skip();};

IDENTIFIER :	 (('a'..'z'|'A'..'Z')(('a'..'z'|'A'..'Z'|'0'..'9')+))|('a'..'z'|'A'..'Z');
	
INTLITERAL :	 (('0'..'9')+);
	
FLOATLITERAL :	 (('0'..'9')+('.')|'.')(('0'..'9')+);
	
STRINGLITERAL:	 '"'~('"')+'"';


WHITESPACE :     ( '\t' | ' ' | '\r' | '\n'| '\u000C' )+    { $channel = HIDDEN; skip();} ;


/* Program */
program:           'PROGRAM' {global = true; funcTable = false; /*System.out.println("Symbol table GLOBAL");*/ item = new MyItem("","Symbol table GLOBAL","",""); symbols.add(item);} id 'BEGIN' pgm_body 'END' 
{
  int i;
  int j;
  int k;
  int m;
  MyItem temp;
  for (i = 0; i < symbols.size(); i++){
    temp = symbols.get(i);
    for (j = i + 1; j < symbols.size();j++){
      if(temp.currentScope.equals("GLOBAL") && temp.name.equals(symbols.get(j).name) && !(symbols.get(j).currentScope.equals("GLOBAL"))){
         shadow.add("SHADOW WARNING "+temp.names[1]);
      }
      else if(!(temp.currentScope.equals(""))&&temp.currentScope.equals(symbols.get(j).currentScope)&&temp.name.equals(symbols.get(j).name)){
        System.out.println("DECLARATION ERROR " + symbols.get(j).names[1]);
        //System.out.println(symbols.get(j).name+symbols.get(j).type+symbols.get(j).value);
        System.exit(0);
      }
    }
  }
  
  for (m = 0; m < shadow.size(); m++){
      System.out.println(shadow.get(m));
    }
    
  for (k = 0; k < symbols.size(); k++){
    
    if(symbols.get(k).name.equals("")&&!(symbols.get(k).type.equals("Symbol table GLOBAL")))
      System.out.printf("\n");
    System.out.printf(symbols.get(k).name+symbols.get(k).type+symbols.get(k).value+"\n");
  }
  //System.out.println("");
}

; 
id:                IDENTIFIER;
pgm_body:          decl func_declarations;
//decl:		       (string_decl (string_decl_tail)? (decl)? | var_decl (var_decl_tail)? (decl)? )?;
decl:              (string_decl  | var_decl )*;

/* Global String Declaration */
string_decl:        'STRING' id ':=' str ';' 
					{if(global)
					   item = new MyItem("name "+ $id.text, " type STRING value ", $str.text, "GLOBAL");
					 else if(funcTable)
					   item = new MyItem("name "+ $id.text, " type STRING value ", $str.text, tableName);
					 else
					   item = new MyItem("name "+ $id.text, " type STRING value ", $str.text, "BLOCK"+Integer.toString(blockn));
					 symbols.add(item);
					 
					/*System.out.println("name "+ $id.text+ " type STRING value "+ $str.text);*/
					 };
str:                STRINGLITERAL;

/* Variable Declaration */
var_decl:           var_type id_listx';';
				

var_type:	        'FLOAT' {intorfloat=0;}
| 'INT'{intorfloat = 1;};
any_type:           var_type | 'VOID' ;
id_listx:         id {
				 if (intorfloat == 0) {
				 if(global)
				    item = new MyItem("name "+$id.text, " type FLOAT", "", "GLOBAL");
			         else if(funcTable)
				    item = new MyItem("name "+$id.text, " type FLOAT", "", tableName);
			         else
				    item = new MyItem("name "+$id.text, " type FLOAT", "", "BLOCK"+Integer.toString(blockn));
			         symbols.add(item);
				 /*System.out.println("name "+$id.text+ " type FLOAT");*/}
				 else {
				 if(global)
				    item = new MyItem("name "+$id.text, " type INT", "", "GLOBAL");
			         else if(funcTable)
				    item = new MyItem("name "+$id.text, " type INT", "", tableName);
			         else
				    item = new MyItem("name "+$id.text, " type INT", "", "BLOCK"+Integer.toString(blockn));
			         symbols.add(item);
				 /*System.out.println("name "+$id.text+ " type INT");*/}
				}
id_tailx ;

id_tailx:            (',' id 
                {
				 if (intorfloat == 0) {
				 if(global)
				    item = new MyItem("name "+$id.text, " type FLOAT", "", "GLOBAL");
			         else if(funcTable)
				    item = new MyItem("name "+$id.text, " type FLOAT", "", tableName);
			         else
				    item = new MyItem("name "+$id.text, " type FLOATT", "", "BLOCK"+Integer.toString(blockn));
			         symbols.add(item);
				 /*System.out.println("name "+$id.text+ " type FLOAT");*/}
				 else {
				 if(global)
				    item = new MyItem("name "+$id.text, " type INT", "", "GLOBAL");
			         else if(funcTable)
				    item = new MyItem("name "+$id.text, " type INT", "", tableName);
			         else
				    item = new MyItem("name "+$id.text, " type INT", "", "BLOCK"+Integer.toString(blockn));
			         symbols.add(item);
				 /*System.out.println("name "+$id.text+ " type INT");*/}
				}

id_tailx)?;

id_list:         id id_tail ;

id_tail:            (',' id 
         
id_tail)?;


/* Function Paramater List */
param_decl_list:    param_decl param_decl_tail;
param_decl:         var_type id
				{
				   if (intorfloat == 0) {
				   if(global)
				     item = new MyItem("name "+$id.text, " type FLOAT", "", "GLOBAL");
			           else if(funcTable)
				     item = new MyItem("name "+$id.text, " type FLOAT", "", tableName);
			           else
				     item = new MyItem("name "+$id.text, " type FLOAT", "", "BLOCK"+Integer.toString(blockn));
			           symbols.add(item);
				   /*System.out.println("name "+$id.text+ " type FLOAT");*/}
				   else {
				   if(global)
				     item = new MyItem("name "+$id.text, " type INT", "", "GLOBAL");
			           else if(funcTable)
				     item = new MyItem("name "+$id.text, " type INT", "", tableName);
			           else
				     item = new MyItem("name "+$id.text, " type INT", "", "BLOCK"+Integer.toString(blockn));
			           symbols.add(item);
				   /*System.out.println("name "+$id.text+ " type INT");*/}
				}
;
param_decl_tail:    (',' param_decl param_decl_tail)?;

/* Function Declarations */
func_declarations:  (func_decl func_decl_tail)?;
func_decl:          'FUNCTION'  any_type id {/*System.out.println("\n"+"Symbol table "+$id.text);*/ item = new MyItem("","Symbol table ",$id.text,""); symbols.add(item);global = false; funcTable = true; tableName = $id.text;}'(' (param_decl_list)? ')' 'BEGIN' func_body 'END';
func_decl_tail:     (func_decl)*;
func_body:          decl stmt_list; 

/* Statement List */
stmt_list:          (stmt stmt_tail)?;
stmt_tail:          (stmt stmt_tail)?;
stmt:               base_stmt | if_stmt | do_while_stmt;
base_stmt:          assign_stmt | read_stmt | write_stmt | return_stmt;

/* Basic Statements */
assign_stmt:        assign_expr ';';
assign_expr:        id ':=' expr ;
read_stmt:          'READ' '(' id_list ')' ';';
write_stmt:         'WRITE' '(' id_list ')' ';';
return_stmt:        'RETURN' expr ';' ;

/* Expressions */
expr:               factor expr_tail;
expr_tail:          (addop factor expr_tail)?;
factor:             postfix_expr factor_tail;
factor_tail:        (mulop postfix_expr factor_tail)?;
postfix_expr:       primary | call_expr;
call_expr:          id '(' (expr_list)? ')';
expr_list:          expr expr_list_tail;
expr_list_tail:     (',' expr expr_list_tail)?;
primary:            '(' expr ')' | id | INTLITERAL | FLOATLITERAL;
addop:              '+' | '-';
mulop:              '*' | '/';

/* Complex Statements and Condition */ 
if_stmt:            'IF'
					{
						blockn += 1;
						funcTable = false;
						global = false;
						item = new MyItem("","Symbol table BLOCK ",Integer.toString(blockn),"");
						symbols.add(item);
						/*System.out.println("\n" + "Symbol table BLOCK " + Integer.toString(blockn))*/;
					}


'(' cond ')' decl stmt_list else_part 'ENDIF';
else_part:          ('ELSIF' 
					{
						blockn += 1;
						funcTable = false;
						global = false;
						item = new MyItem("","Symbol table BLOCK ",Integer.toString(blockn),"");
						symbols.add(item);
						/*System.out.println("\n" + "Symbol table BLOCK " + Integer.toString(blockn))*/;
					}

'(' cond ')' decl stmt_list)*;
cond:               expr compop expr | 'TRUE' | 'FALSE';
compop:             '<' | '>' | '=' | '!=' | '<=' | '>=';

/* ECE 573 students use this version of do_while_stmt */
do_while_stmt:      'DO'
					{
						blockn += 1;
						funcTable = false;
						global = false;
						item = new MyItem("","Symbol table BLOCK ",Integer.toString(blockn),"");
						symbols.add(item);
						/*System.out.println("\n" + "Symbol table BLOCK " + Integer.toString(blockn))*/;
					}


(string_decl  |  var_decl )* aug_stmt_list 'WHILE' '(' cond ')' ';';

/* CONTINUE and BREAK statements. ECE 573 students only */
aug_stmt_list:      (aug_stmt aug_stmt_list)?;
aug_stmt:           base_stmt | aug_if_stmt | do_while_stmt | 'CONTINUE' ';' | 'BREAK' ';';

/* Augmented IF statements for ECE 573 students */ 
aug_if_stmt:        'IF' 
					{
						blockn += 1;
						funcTable = false;
						global = false;
						item = new MyItem("","Symbol table BLOCK ",Integer.toString(blockn),"");
						symbols.add(item);
						/*System.out.println("\n" + "Symbol table BLOCK " + Integer.toString(blockn))*/;
					}


'(' cond ')' (string_decl  | var_decl )* aug_stmt_list aug_else_part 'ENDIF';
aug_else_part:      ('ELSIF'
					{
						blockn += 1;
						funcTable = false;
						global = false;
						item = new MyItem("","Symbol table BLOCK ",Integer.toString(blockn),"");
						symbols.add(item);
						/*System.out.println("\n" + "Symbol table BLOCK " + Integer.toString(blockn))*/;
					}

'(' cond ')' (string_decl  | var_decl )* aug_stmt_list aug_else_part)?;
