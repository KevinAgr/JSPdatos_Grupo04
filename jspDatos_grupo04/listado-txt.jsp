<%@page import="java.util.*, java.sql.*,net.ucanaccess.jdbc.*" pageEncoding="utf-8"%>
<%
   response.setStatus(200);
   response.setContentType("application/xml");
   response.setHeader("Content-Disposition","attachment; filename=" + "listadoLibros.txt" );
%>
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
   int i=1,anio;
   String isbn, titulo,autor,editorial;
   while (rs.next())
   {
        isbn = rs.getString("isbn");
        titulo = rs.getString("titulo");
        autor = rs.getString("autor");
        anio = rs.getInt("anio");
        editorial = rs.getString("nombre");
        
        out.println("Número: "+i);
        out.println("ISBN: "+isbn);
        out.println("Titulo: "+titulo);
        out.println("Autor: "+autor);
        out.println("Editorial: "+editorial);
        out.println("Año de Publicación: : "+anio+"\n"); 
        out.println("----------------------------------"); 

        i++;
   }
   // cierre de la conexion
   conexion.close();
}
%>