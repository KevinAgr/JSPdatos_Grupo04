<%@page contentType="text/html" pageEncoding="utf-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>Actualizar, Eliminar, Crear registros.</title>
   <link rel="stylesheet" href="css/bulma.min.css">
</head>
<body>
<%!
public Connection getConnection() throws SQLException {
String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
String userName="libros",password="books";
String fullConnectionString = "jdbc:odbc:registro";

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
Connection conexion = getConnection();
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
   <div class="columns m-2">
   <div class="column is-4">
		<article class="message is-info">
  			<div class="message-header ">
				<h1>Mantenimiento de libros</h1>
    		</div>
		  <div class="message-body field">
			   <form action="matto.jsp" method="post" name="Actualizar">
				  <div class="columns">
					  <div class="column">
						  <label for="nombre" class="label">ISBN: </label>
						  <div class="control">
                        <input type="text" class="input is-rounded" name="isbn" value="<% if (request.getParameter("isbn") != null) out.println(request.getParameter("isbn"));%>" size="13" maxlength="13" pattern="[0-9]{13}" title="Debe ingresar 13 digitos" required/>
						  </div>
					  </div>
				  </div>
				  <div class="columns">
					  <div class="column">
						  <label for="nombre" class="label">Título: </label>
						  <div class="control">
                        <input type="text" class="input is-rounded" name="titulo" value="<% if (request.getParameter("titulolibro") != null) out.println(request.getParameter("titulolibro"));%>" size="50" pattern="[a-zA-Z0-9\,]{0,50}" title="Solo debe ingresar texto y maximo 50 caracteres" required/>                  
						  </div>
					  </div>
				  </div>
              <div class="columns">
					  <div class="column">
						  <label for="nombre" class="label">Autor: </label>
						  <div class="control">
                        <input type="text" class="input is-rounded" name="autor" value="<% if (request.getParameter("autor") != null) out.println(request.getParameter("autor"));%>" size="50" required  pattern="[a-zA-Z\,]{0,50}" title="Solo debe ingresar texto sin acento y maximo 50 caracteres" />  
						  </div>
					  </div>
				  </div>
              <div class="columns">
					  <div class="column">
						  <label for="nombre" class="label">Año de publicación: </label>
						  <div class="control">
                        <input type="text" class="input is-rounded" name="anio" value="<% if (request.getParameter("anio") != null) out.println(request.getParameter("anio"));%>" size="10" required pattern="[0-9]{4}" title="Debe ingresar un año"/>            
						  </div>
					  </div>
				  </div>
               <div class="column">
						   <label for="perfil" class="label">Editorial: </label>
						   <div class="control">
							   <div class="select">
                          <select name="editorial" class="input is-rounded">
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
                           </select> 
                        </div>
						   </div>
					  </div>
                 <div class="columns">
					  <div class="column">
						  <label for="nombre" class="label">Acción: </label>
						  <div class="control">
                        <% 
                  if (request.getParameter("actualizar") != null)
                     out.println("<label class='radio'><input type='radio' name='Action' value='Actualizar' checked/> Actualizar </label> <label class='radio'><input type='radio' name='Action' value='Crear'/> Crear  </label>");
                  else 
                     out.println("<label class='radio'> <input type='radio' name='Action' value='Actualizar'/>Actualizar </label> <label class='radio'> <input type='radio' name='Action' value='Crear' checked/> Crear  </label>");              
               %>                                   
						  </div>
					  </div>
				  </div>
				  <button class="button is-success" type="submit">
					  <span>ACEPTAR</span>
				  </button>
			  </form>
		  </div>
		</article>
	</div>
   <div class="column is-8">
   <form name="formbusca" action="libros.jsp" method="POST">
      <div>
         <b>Titulo a buscar:</b>
         <input type="text" class="input is-rounded" name="titulo" onkeyup="changeInput()" placeholder="ingrese un título" pattern="[a-zA-Z0-9\,]{0,30}">
      </div>
      <br>
      <div>
         <b>Autor a buscar:</b>
         <input type="text" class="input is-rounded" name="escritor" onkeyup="changeInput()" placeholder="ingrese un autor"  pattern="[a-zA-Z\,]{0,30}">
      </div>
      <div class="mt-4">
         <input type="submit" class="button is-info is-small" id="buscar" name="buscar" value="BUSCAR" disabled>
         <a href="libros.jsp">Mostrar todos los resultados</a>
         <a href="listado-csv.jsp" download="libros.csv">CSV </a>
         <a href="listado-txt.jsp" download="libros.txt">Texto plano</a>
         <a href="listado-xml.jsp" download="libros.xml">XML</a>
         <a href="listado-json.jsp" download="libros.json" class="btn btn-outline-dark">JSON</a>
         <a href="listado-html.jsp" download="libros.html" class="btn btn-outline-dark">HTML</a>
      </div>
   </form>
   <div class="table-container">
<% 
   rs = st.executeQuery(query);
   // Ponemos los resultados en un table de html
   out.println("<table class='table is-full' border=\"1\"><tr><td>Num.</td><td>ISBN</td><td><a href='libros.jsp?order="+order+"'>Título</a></td><td>Autor</td><td>Editorial</td><td>Año de publicación</td><td>Acción</td></tr>");
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
      </div>
   </div>
</div>
<script src="js/script.js"></script>
</body>