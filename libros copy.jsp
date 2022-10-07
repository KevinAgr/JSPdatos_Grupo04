<%@page contentType="text/html" pageEncoding="utf-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>Actualizar, Eliminar, Crear registros.</title>
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
<%
ServletContext context = request.getServletContext();
String path = context.getRealPath("/data");
Connection conexion = getConnection(path);
if (!conexion.isClosed()) { 
   String order = request.getParameter("order");
   String title = request.getParameter("titulo");
   String escritor = request.getParameter("escritor");

   if (order != null) 
      if (order.equals("asc")) 
         order = "desc";
      else 
         order = "asc";
   else 
      order = "asc";
   String query = "select isbn,titulo,autor,anio,e.nombre, editorial from libros l INNER JOIN editorial e ON e.id = l.editorial ";
   if (title != null) {
      query += "where titulo LIKE '%"+title+"%' ";
      if (escritor != null)
         query += "AND autor LIKE '%"+escritor+"%' ";
   } else 
      if (escritor != null)
         query += "where autor LIKE '%"+escritor+"%' ";   
   query += "order by titulo "+ order;
   Statement st = conexion.createStatement();
   ResultSet rs;
%>
   <H1>MANTENIMIENTO DE LIBROS</H1>
   <form action="matto.jsp" method="post" name="Actualizar">
      <table>
         <tr>
            <td>ISBN:<input type="text" name="isbn" value="<% if (request.getParameter("isbn") != null) out.println(request.getParameter("isbn"));%>" size="40" required/></td>
         </tr>
         <tr>
            <td>Título:<input type="text" name="titulo" value="<% if (request.getParameter("titulolibro") != null) out.println(request.getParameter("titulolibro"));%>" size="50" required/></td>
         </tr>
         <tr>
            <td>Autor:<input type="text" name="autor" value="<% if (request.getParameter("autor") != null) out.println(request.getParameter("autor"));%>" size="50" required /></td>
         </tr>
         <tr>
            <td>Año de publicación:<input type="text" name="anio" value="<% if (request.getParameter("anio") != null) out.println(request.getParameter("anio"));%>" size="10" required /></td>
         </tr>
         <tr>
            <td>Editorial:<select name="editorial">
            <%
               rs = st.executeQuery("select * from editorial");
               String id;            
               while (rs.next())
               {
                  id = rs.getString("id");
                  if (id.equals(request.getParameter("editorial")))
                     out.println("<option value='"+id+"' selected>"+rs.getString("nombre")+"</option>");
                  else 
                     out.println("<option value='"+id+"' >"+rs.getString("nombre")+"</option>");
               }
            %>         
            </select></td>
         </tr>
         <tr>
            <td>
               Action 
               <% 
                  if (request.getParameter("actualizar") != null)
                     out.println("<input type='radio' name='Action' value='Actualizar' checked/> Actualizar <input type='radio' name='Action' value='Crear'/> Crear");
                  else 
                     out.println("<input type='radio' name='Action' value='Actualizar'/> Actualizar<input type='radio' name='Action' value='Crear' checked/> Crear");              
               %>               
            </td>
            <td>
               <input type="SUBMIT" value="ACEPTAR" /> 
            </td>
         </tr>
      </table>
   </form>
   <br>
   <form name="formbusca" action="libros.jsp" method="POST">
      <div>
         Titulo a buscar: 
         <input type="text" name="titulo" onkeyup="changeInput()" placeholder="ingrese un título">
      </div>
      <br>
      <div>
         Autor a buscar: 
         <input type="text" name="escritor" onkeyup="changeInput()" placeholder="ingrese un autor">
      </div>
      <input type="submit" id="buscar" name="buscar" value="BUSCAR" disabled>
      <a href="libros.jsp">Mostrar todos los resultados</a>
   </form>
<% 
   rs = st.executeQuery(query);
   // Ponemos los resultados en un table de html
   out.println("<table border=\"1\"><tr><td>Num.</td><td>ISBN</td><td><a href='libros.jsp?order="+order+"'>Título</a></td><td>Autor</td><td>Editorial</td><td>Año de publicación</td><td>Acción</td></tr>");
   int i=1, anio;
   String isbn, titulo,autor;
   while (rs.next())
   {
      isbn = rs.getString("isbn");
      titulo = rs.getString("titulo");
      autor = rs.getString("autor");
      anio = rs.getInt("anio");
      out.println("<tr>");
      out.println("<td>"+ i +"</td>");
      out.println("<td>"+ isbn +"</td>");
      out.println("<td>"+titulo+"</td>");
      out.println("<td>"+autor+"</td>");
      out.println("<td>"+rs.getString("nombre")+"</td>");
      out.println("<td>"+anio+"</td>");
      out.println("<td><a href='libros.jsp?isbn="+isbn+"&titulolibro="+titulo+"&autor="+autor+"&anio="+anio+"&editorial="+rs.getString("editorial")+"&&actualizar'>Actualizar</a><br><a href='matto.jsp?Action=Eliminar&isbn="+isbn+"'>Eliminar</a></td>");
      out.println("</tr>");
      i++;
   }
   out.println("</table>");

   // cierre de la conexion
   conexion.close();
}

%>
<script src="js/script.js"></script>
</body>