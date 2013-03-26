<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            function findNext(id,label){                
                var xmlhttp=new XMLHttpRequest();
                xmlhttp.onreadystatechange=function(){
                    if(xmlhttp.readyState===4 && xmlhttp.status===200)
                        {
                            var res=xmlhttp.responseText;
                            var type=res.substring(0,res.indexOf("///"));
                            res=res.substring(res.indexOf("///")+3);
                            if(type==="Problem"){
                               var prob=res.substring(0, res.indexOf("///"));
                               res=res.substring(res.indexOf("///")+3);                               
                               var pdesc=res.substring(0, res.indexOf("///"));
                               res=res.substring(res.indexOf("///")+3);                               
                               var pid=res.substring(0, res.indexOf("///"));
                               res=res.substring(res.indexOf("///")+3);                               
                               var yesL=res.substring(0, res.indexOf("///"));
                               res=res.substring(res.indexOf("///")+3);                               
                               var noL=res;                               
                               document.getElementById("prob").innerHTML=prob;
                               document.getElementById("pdesc").innerHTML=pdesc;
                               document.getElementById("buttons").innerHTML="<input type=\"button\" value=\"Yes\" onclick=\"findNext("+pid+","+yesL+");\"/><input type=\"button\" value=\"No\" onclick=\"findNext("+pid+","+noL+");\"/>";
                            }
                            else if(type==="Solution"){
                                var soln=res;
                                document.getElementById("prob").innerHTML="";
                                document.getElementById("pdesc").innerHTML=soln;
                                document.getElementById("buttons").innerHTML="<a href=\"\">Home</a>";
                                }                                                        
                        }
                };
                xmlhttp.open("POST","Servlet1",true);
                xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                var sendstr="pid="+id+"&labelid="+label;
                xmlhttp.send(sendstr);
            }
        </script>
    </head>
    <body>
        <jsp:directive.page import="java.sql.*;" />
        <jsp:declaration>
            Connection con;
            Statement s;
            ResultSet rs;
            String sql;
            String pid=null,prob=null,pdesc=null,yesL=null,noL=null;
            
            public void jspInit(){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                con=DriverManager.getConnection("jdbc:mysql://localhost:3306/cdt", "root", ".hack%//sign66");
                s=con.createStatement();
                
                sql="select * from cdt.problem where pid='1.01'";
                rs=s.executeQuery(sql);
                rs.next();
                
                pid=rs.getObject("pid").toString();
                prob=rs.getObject("problm").toString();
                pdesc=rs.getObject("pdesc").toString();
                yesL=rs.getObject("yesL").toString();
                noL=rs.getObject("noL").toString();
            
            }
            catch(Exception e){
                e.printStackTrace();
            }
            }
            public void jspDestroy(){
                try{
                rs.close();
                s.close();
                con.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
        </jsp:declaration>
        
        <!--STYLE THESE 2 <P> STATEMENTS-->
        <p id="prob" style="position:absolute;left:240px;top:48px;width:425px;height:70px;text-align:center;"><%=prob%></p>
        <p id="pdesc" style="position:absolute;left:150px;top:88px;width:725px;height:470px;text-align:center;"><%=pdesc%></p>
        <form><p id="buttons">
               <input type="button" style="position:absolute;left:400px;top:468px;text-align:center;" value="Yes" onclick="findNext(<%=pid%>,<%=yesL%>);"/>
               <input type="button" style="position:absolute;left:450px;top:468px;text-align:center;" value="No" onclick="findNext(<%=pid%>,<%=noL%>);"/>
            </p></form>
    </body>
</html>