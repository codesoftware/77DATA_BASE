Notas:
1. La secuencia que se utiliza para los movimientos contables es co_temp_movi_contables
2. Despues de ejecutar el comand instalador se debe correr los insert que estan en clientes77.sql
3. se debe ejecutar f_cargacliente();
4. despues de subir los productos se debe ejecutar in_cambia_panel_pedidos()
5. Cundo se realice el proceso de cargue por medio del excel no va ha ingresar ningun precio ni existencia,
   se debe correr el proceso FA_INSERTA_PROD_MASIVO , despues de parametrizar todos los porcentajes de precios