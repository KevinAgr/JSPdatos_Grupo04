<%@page import="java.util.*,java.sql.*,net.ucanaccess.jdbc.*" contentType="application/json" pageEncoding="utf-8"%>{<%
    response.setStatus(200);
    //response.setContentType("application/json");
    String nombreArchivo = "libros.json";
    response.setHeader("Content-Disposition", "attachment; filename=" + nombreArchivo);
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
%>
    "<%=i%>" : {
            "libro": {
                "isbn": "<%=isbn%>",
                "titulo": "<%=titulo%>",
                "autor": "<%=autor%>",
                "editorial": "<%=editorial%>",
                "anio": "<%=anio%>"
            }
        },
<%
        i++;
   }
   // cierre de la conexion
   conexion.close();
}
%>