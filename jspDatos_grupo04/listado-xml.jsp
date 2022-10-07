<%@page import="java.util.*,java.sql.*,net.ucanaccess.jdbc.*" contentType="application/xml" pageEncoding="utf-8"%>
<%
    response.setStatus(200);
    String nombreArchivo = "libros.xml";
    response.setHeader("Content-Disposition", "attachment; filename=" + nombreArchivo);
%>
<?xml version="1.0" standalone="yes"?>
<?xml-stylesheet type="text/css" href="css/style_xml.css" ?>
    <biblioteca>
    <encabezado>
        <tituloP>Mantenimiento de Libros.</tituloP>
    </encabezado>
    <libros>
<%!
public Connection getConnection(String path) throws SQLException {
String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
String filePath= path + "\\datos.mdb";
String userName="",password="";
String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;

Connection conn = null;
try{
   Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
   conn = DriverManager.getConnection(fullConnectionString,userName,password);
}
catch (Exception e) {
   System.out.println("Error: " + e);
}
return conn;
}
%>
<%
ServletContext context = request.getServletContext();
String path = context.getRealPath("jspDatos_grupo04/data");
Connection conexion = getConnection(path);
if (!conexion.isClosed()) { 
   String query = "select isbn,titulo,autor,anio,e.nombre as nombre from libros l INNER JOIN editorial e ON e.id = l.editorial order by titulo";
   Statement st = conexion.createStatement();
   ResultSet rs = st.executeQuery(query);
   out.println("<tabla><cabecera><numeros>Num.</numeros><isbns>ISBN</isbns><titulos>Titulo</titulos><autores>Autor</autores><editoriales>Editorial</editoriales><anios>Año Publicación</anios></cabecera>");
   int i=1,anio;
   String isbn, titulo,autor,editorial;
   while (rs.next())
   {
        isbn = rs.getString("isbn");
        titulo = rs.getString("titulo");
        autor = rs.getString("autor");
        anio = rs.getInt("anio");
        editorial = rs.getString("nombre");
        
        out.println("<libro><numero>"+i+"</numero><isbn>"+isbn+"</isbn><titulo>"+titulo+"</titulo><autor>"+autor+"</autor><editorial>"+editorial+"</editorial><anio>"+anio+"</anio></libro>");
        i++;
   }
   // cierre de la conexion
   conexion.close();
}
%>
        </tabla>
    </libros>
</biblioteca>