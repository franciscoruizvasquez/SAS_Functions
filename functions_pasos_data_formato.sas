DATA EJERCICIO_VAR_NUMERICA ;
 SET SASHELP.PRICEDATA (obs=10);
 s_precio = sum( of price1-price17); 
 total= s_precio-cost-discount;
RUN;


data capitulo3_1;
*Damos formatos a las fechas;
format fecha_1 yymmddn8. fecha_2 ddmmyy8. fecha_3 ddmmyy10. fecha_4 date9. fecha_5 fecha_6 date7.;

* Ejemplos fechas, misma fecha distinta visualizaci�n;
fecha_1="01MAR2017"d;
fecha_2="01MAR2017"d;
fecha_3="01MAR2017"d;
fecha_4="01MAR2017"d;

*Funcion fecha actual;
fecha_5=today();

* Si queremos añadir 2 años a la fecha_5 empleamos INTNX y el resultado ser� una fecha.;

/* d = date e end b principio m en el medio same  */
fecha_6 = intnx("month",fecha_5, 2, "e");

*Diferencia de fechas;
dif=intck("year", "09APR2017"d,  "09APR2019"d);

*Diferencia de fechas con los campos;
dif2=intck("year", fecha_5, fecha_6);

format A $30.  B $3.  C $20. D $17. E Z6.;
A='SAS_Programacion  ---  ';

B=substr(A,1,3); 					*Nos quedamos solo con los 3 primeros caracteres;
C=compress(A); 						*Quitamos espacios;
D=compress(Compress(A,'-', ''));  	*Quitamos espacios y guiones;
E=203;								*A�adimos ceros a la izquierda;
run;	


** De alfanumerico (texto) a numerico (numero);
data capitulo3_2;

*Input;
char1="2017"; 
char2="01/11/201";  

*mejor forma de hacerlo;
forma1_1= INPUT (char1, best16.);     

format forma1_2 date9.; 
forma1_2= INPUT (char2, ddmmyy10.);

forma2_1= char1*1;
forma2_2= Compress(char2,'/', '')*1;

run;	


** De numerico (numero) a alfanumerico (texto);
data capitulo3_3;
*Input;
num1=2017; 

format num2 ddmmyy8.; 
num2="09APR2017"d;  

num3=201812032;

format forma1_1 $4. forma1_2 $10.; 
forma1_1= compress( PUT (num1, 8.) );
forma1_2= PUT (num2, date9.);

nume3_format = PUT (num3,date9.);


format forma2_1 $4. forma2_2 $10.; 
forma2_1= num1;
forma2_2= num2; *no funciona con fechas;


run;	


data funciones_f;
length fecha1_num fecha2_num 8.;
fecha1_num = 20121101;
fecha2_num = 01102013;
fecha_h_date = today();

format fecha1_date date9.;format fecha2_date date9.;
fecha1_date = mdy((mod((int(fecha1_num/100)),100)),(mod(fecha1_num,100)),(int(fecha1_num/10000)));
put fecha1_date;
put fecha2_date;

run;



 /* Usar el procedimiento PRINT para visualizar la información de las tablas: class y classfit.
  * añade un titulo distinto para cada salida  (tittle) para identificar correctamente cada tabla
 */

PROC PRINT DATA=SASHELP.CLASS;
 TITLE "TABLA CLASS";
RUN;
PROC PRINT DATA=SASHELP.CLASSFIT;
 TITLE "TABLA CLASSFIT";
RUN;

/********************/
/* Usando Funciones */
/********************/

/*-----------*/
/* NUMERICAS */
/*-----------*/
/* En la tabla PriceData, de sashelp, se necesita saber lo siguiente:
* 1/ La suma de todos los precios con sub_indice y comparalo con price
* 2/ Haz la diferencia entre todos los precios con sub_indice y resta el descuento y el coste del producto
* 3/ Calcula con la diferencia de la venta
*/
PROC PRINT DATA=SASHELP.PRICEDATA;
RUN;

DATA EJERCICIO_VAR_NUMERICA ;
 SET SASHELP.PRICEDATA (obs=10);
 s_precio = sum( of price1-price17); 
 total= s_precio-cost-discount;
RUN;

SUMA_PRECIOS = price1 + price2 + price3 + price4 + price5 + price6 + price7 + price8 + price9 +
		               price10 + price11 + price12 + price13 + price14 + price15 + price16 + price17; 
COMPARACION_PRECIO = SUMA_PRECIOS / PRICE; 

RUN;


/*----------------*/
/* ALFANUMERICAS */
/*----------------*/
/* En la tabla Cars, de sashelp, se necesita clasificar la informacion de Model, de manera que se puedan analizar,
 * por ejemplo: Marcas_1 (Cadillac, Jaguar, Porsche), Marcas_2 (Audi, BMW y Mercedes-Benz), Marcas_3 (resto de Make)
*/

PROC PRINT DATA=SASHELP.CARS;
RUN;

DATA TABLA_CARS;
 SET SASHELP.CARS (OBS=5);
 /*RUN;*/
 
 IF upcase(Make)='CADILLAC' OR upcase(Make)='Jaguar' OR upcase(Make)='Porsche' then Tipo_de_marca = "Marcas_1";
  else IF Make='Audi' OR Make='BMW' OR Make='Mercedes-Benz' then Tipo_de_marca = "Marcas_2";
   else Tipo_de_marca = "Marcas_3";

 IF upcase(Make) IN ('CADILLAC', 'JAGUAR', 'PORSCHE') then Tipo_marca = 1;
RUN;

/* En la tabla Shoes, de sashelp, se necesita depurar y limpiar el campo Product para poder utilizar el campo después.
 * El campo product no debe tener simbolos raros y los espacios que haya se deben cambiar por guiones 
   de manera que se pudiesen utilizar como campos.
 * Guardar el resultado en una libreria permanente y el nombre de la tabla Shoes_product_limpio.
*/
PROC PRINT DATA=SASHELP.SHOES;
RUN;

DATA Shoes_product_limpio;
 SET SASHELP.SHOES;
 FORMAT VARIABLE_NORMALIZADA VARIABLE_NORMALIZADA3 $CHAR15.;
 *VARIABLE_NORMALIZADA = TRANWRD(Product,'','-');
 *VARIABLE_NORMALIZADA2 = COMPRESS(VARIABLE_NORMALIZADA,"'");

 VARIABLE_NORMALIZADA3 = COMPRESS( TRANWRD(Product,'','_') ,"'");
RUN;




/*------------*/
/* CONVERSION */
/*------------*/
/* En la tabla Shoes, de sashelp, el campo Stores se necesita como alfanumerico y que complete ceros a la izquierda hasta 5.
 */

DATA TABLA_SHOES;
 SET SASHELP.SHOES;
 format char_var $CHAR6.;
 char_var = put(Stores,6. -R);
 char_var2 = put(INPUT(char_var,BEST.),z6.);
RUN;



/*--------*/
/* FECHA  */
/*--------*/
/* De la tabla TimeData, en sashelp, extraer el año, el mes, el dia y la fecha con el formato yymmddN.
 * Calcular la diferencia de meses y de años con la diferencia actual
*/

PROC PRINT DATA = SASHELP.TIMEDATA;
RUN;

DATA EJERCICIO3;
 SET SASHELP.TIMEDATA;
 format date yymmddn8.;
 date=datepart(datetime);
 dif_year = intck("year",date,today());
 dif_month = intck("month",date,today());
RUN;
    
/*
 * De la tabla CountSeries, en sashelp, extraer el año, el mes, el dia y la fecha con el formato DateTime.
 * Calcular el numero de años que difiere con respecto a la fecha actual.
 */
PROC PRINT DATA = SASHELP.CountSeries;
RUN;

DATA EJERCICIOFINAL;
 SET SASHELP.COUNTSERIES;
 FORMAT date_final datetime.;
 date_final = date;
 dif_year = intck("year",date_final,today());

RUN;