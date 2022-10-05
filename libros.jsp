<%@page contentType="text/html" pageEncoding="utf-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>Actualizar, Eliminar, Crear registros.</title>
</head>
<body>
   <H1>MANTENIMIENTO DE LIBROS</H1>
   <form action="matto.jsp" method="post" name="Actualizar">
      <table>
         <tr>
            <td>ISBN<input type="text" name="isbn" value="" size="40"/></td>
         </tr>
         <tr>
            <td>Título<input type="text" name="titulo" value="" size="50"/></td>
         </tr>
         <tr>
            <td>Autor<input type="text" name="autor" value="" size="50"/></td>
         </tr>
         <tr>
            <td>
               Action 
               <input type="radio" name="Action" value="Actualizar" /> Actualizar
               <input type="radio" name="Action" value="Crear" checked /> Crear
            </td>
            <td>
               <input type="SUBMIT" value="ACEPTAR" /> 
            </td>
         </tr>
      </table>
   </form>
   <br>
   <form name="formbusca" action="libros.jsp" method="POST">
      Titulo a buscar: 

      <input type="text" name="titulo" placeholder="ingrese un título">
      <input type="submit" name="buscar" value="BUSCAR">
   </form>
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
String path = context.getRealPath("/data");
Connection conexion = getConnection(path);
if (!conexion.isClosed()) { 
   out.write("OK");

   String order = request.getParameter("order");
   String title = request.getParameter("titulo");

   if (order != null) 
      if (order.equals("asc")) 
         order = "desc";
      else 
         order = "asc";
   else 
      order = "asc";
      
   Statement st = conexion.createStatement();
   String query = "select * from libros ";
   if (title != null) 
      query += "where titulo LIKE '%"+title+"%' ";
   query += "order by titulo "+ order;
   ResultSet rs = st.executeQuery(query);
 
   // Ponemos los resultados en un table de html
   out.println("<table border=\"1\"><tr><td>Num.</td><td>ISBN</td><td><a href='libros.jsp?order="+order+"'>Título</a></td><td>Autor</td><td>Acción</td></tr>");
   int i=1;
   String isbn, titulo,autor;
   while (rs.next())
   {
      isbn = rs.getString("isbn");
      titulo = rs.getString("titulo");
      autor = rs.getString("autor");
      out.println("<tr>");
      out.println("<td>"+ i +"</td>");
      out.println("<td>"+ isbn +"</td>");
      out.println("<td>"+titulo+"</td>");
      out.println("<td>"+autor+"</td>");
      out.println("<td><a href='libros.jsp?isbn="+isbn+"&titulolibro="+titulo+"'>Actualizar</a><br><a href='matto.jsp?Action=Eliminar&isbn="+isbn+"'>Eliminar</a></td>");
      out.println("</tr>");
      i++;
   }
   out.println("</table>");

   // cierre de la conexion
   conexion.close();
}

%>
</body>