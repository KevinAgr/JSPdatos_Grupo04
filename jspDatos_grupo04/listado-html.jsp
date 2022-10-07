<%@page contentType="text/html" pageEncoding="utf-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>Listado de libros.</title>
</head>
<body>
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
<H1>LISTADO DE LIBROS</H1>
<%
ServletContext context = request.getServletContext();
String path = context.getRealPath("jspDatos_grupo04/data");
Connection conexion = getConnection(path);
if (!conexion.isClosed()) { 
   String query = "select isbn,titulo,autor,anio,e.nombre as nombre from libros l INNER JOIN editorial e ON e.id = l.editorial order by titulo";
   Statement st = conexion.createStatement();
   ResultSet rs = st.executeQuery(query);
   int i=1,anio;
   String isbn, titulo,autor,editorial;
   out.println("<table border=\"1\"><tr><td>Num.</td><td>ISBN</td><td>Título</a></td><td>Autor</td><td>Editorial</td><td>Año de publicación</td></tr>");
   while (rs.next())
   {
        isbn = rs.getString("isbn");
        titulo = rs.getString("titulo");
        autor = rs.getString("autor");
        anio = rs.getInt("anio");
        editorial = rs.getString("nombre");
        out.println("<tr>");
        out.println("<td>"+ i +"</td>");
        out.println("<td>"+ isbn +"</td>");
        out.println("<td>"+titulo+"</td>");
        out.println("<td>"+autor+"</td>");
        out.println("<td>"+editorial+"</td>");
        out.println("<td>"+anio+"</td>");
        out.println("</tr>");
        i++;
   }
   // cierre de la conexion
   conexion.close();
}
%>
