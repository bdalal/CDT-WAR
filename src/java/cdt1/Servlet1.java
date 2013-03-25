package cdt1;

import cdt.FindNextLabelLocal;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ejb.EJB;

public class Servlet1 extends HttpServlet {

    Connection con;
    Statement s;
    ResultSet rs;    
    @EJB private FindNextLabelLocal obj;
    
    @Override
    public void init(ServletConfig config) throws ServletException{
        try{
            Class.forName("com.mysql.jdbc.Driver");
            con=DriverManager.getConnection("jdbc:mysql://localhost:3306/cdt", "root", ".hack%//sign66");
            s=con.createStatement();
            
        }
        catch(Exception e){
            e.printStackTrace();
        }            
    }
            
    @SuppressWarnings("UnusedAssignment")
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String pid,label,res,prob,pdesc,yesL,noL;
            @SuppressWarnings("UnusedAssignment")
            float current,next;
            
            current=next = 0;
            pid=request.getParameter("pid").toString(); // pid of the question
            label=request.getParameter("labelid").toString(); //label of the next question or solution based on button press
            current=Float.parseFloat(pid);
            next=Float.parseFloat(label);
            
            res=obj.findNext(current,next).toString();
            if(res.indexOf("///end")!=-1){
                out.write("Solution///"+res.substring(0,res.indexOf("///end")));
                //res=res.substring(0,res.indexOf("///end"));
                //out.write(res);
            }
            else if(res.indexOf("///end")==-1){
                out.write("Problem///"+res);
                /*prob=res.substring(0, res.indexOf("///"));
                res=res.substring(res.indexOf("///")+3);
                pdesc=res.substring(0, res.indexOf("///"));
                res=res.substring(res.indexOf("///")+3);
                pid=res.substring(0, res.indexOf("///"));
                res=res.substring(res.indexOf("///")+3);
                yesL=res.substring(0, res.indexOf("///"));
                res=res.substring(res.indexOf("///")+3);
                noL=res;
                
                out.write(pid);
                out.write(prob);
                out.write(pdesc);
                out.write(yesL);
                out.write(noL);*/
            }
            out.write(res);
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally {            
            out.close();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
