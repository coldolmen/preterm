
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(navbarPage("PREVENTING PREMATURITY",theme=shinytheme("cerulean"),
  
  
  
tabPanel("Cervix",
         sidebarLayout(
                    sidebarPanel(
                      
                            fixedRow(column(6, radioButtons("pretermino","Pretermino o RPM <34 anterior",c("Si"="si","No"="no"),selected="no")),
                                 column(6,radioButtons("incompetencia","Incompetencia cervical documentada",c("Si"="si","No"="no"),selected="no"))),
                                 fixedRow(column(6,radioButtons("perdidas","Perdida fetal 2trim o inicio del 3trim",c("ninguna"="0","1"="1","2"="2","3 o mas"="3"),selected="0")),
                                 
                                column(6, radioButtons("conos","Conizaciones previas",c("Si"="si","No"="no"),selected="no"))),
                            fixedRow(column(6,  radioButtons("unaincompetencia","Un atcd incompetencia",c("Si"="si","No"="no"),selected="no")),
                               column(6, radioButtons("incierto","Diagnostico incierto de Incometencia cervical",c("Si"="si","No"="no"),selected="no"))),
                            fixedRow(column(6, radioButtons("otros","Otros factores de riesgo*",c("Si"="si","No"="no"),selected="no")),
                               column(6,radioButtons("acortamiento","Acortamiento progresivo",c("Si"="si","No"="no"),selected="no"))),
                                                      
                      fixedRow(column(6, numericInput("lcx","Longitud Cervical",min=0,max=60,value=25)),
                         column(6,dateInput("lmd",
                                           "Fecha Ultima Menstruacion",
                                           value=Sys.Date()-180, 
                                           format="dd-mm-yyyy", startview="month", weekstart=1,
                                           language="es"))),
                      htmlOutput ("otrosfactores")
                                 
                    ),
                    mainPanel(fixedRow(h4(sidebarPanel(textOutput("messageweeks"),width=8))),
                              fixedRow(column (1,h6("")),column(6,h4(textOutput("APP")))),
                              fixedRow(column (1,h6("")),column(4,h5(textOutput("TESTANDO")))),
                              fixedRow(column (1,h6("")),column(4,h4(textOutput("APP2")))),
                              fixedRow(column (2,h6("")),column(4,h4("CONDUCTA ACONSEJADA:", align="left"))),
                              h4(verbatimTextOutput("algoritmoprint"),align="center",width=8),
                              br(),
                    actionButton ("borrar", "Reiniciar", value=FALSE),
                    br(),br(),
                    
                    fixedRow(column(5,h6("")),column(6,p(icon("copyright"),em("Juan Acosta Diez"))))
                    ))),

tabPanel("Gemelares",
         sidebarLayout(
           sidebarPanel(
             numericInput("sem2","Semanas de gestacion",min=10,max=38,value=20,width=100),
             numericInput("lcx2","Longitud Cervical",min=0,max=60,value=25,width=100),
             radioButtons("prolapso","Exposicion de las membranas a vagina",c("Si"="si","No"="no"),selected = "no")
             
           ),
           mainPanel(
             h2(textOutput("consejost2")),
             em(textOutput("pctwin")),hr(),
             h5(textOutput("riskt1")),
             h5(textOutput("riskt2")),
             h5(textOutput("riskt3")),
             h5(textOutput("riskt4")),br(),
             fixedRow(column(9,h3(verbatimTextOutput("consejost") ))),
             br(),
             htmlOutput("consideracionest"),
             br(),br(),
             fixedRow(column(4,h6("")),column(6,p(icon("copyright"), em("Juan Acosta"))))
             
              
                
                
                )
           )
         
         
         ),
tabPanel("Informacion",
         mainPanel(
           h3("ACERCA DE TOCOGINAPP: Aplicacion creada exclusivamente para especialistas medicos"),
           br(),
           h5(
             "Esta es una aplicacion creada para ayudar a los ginecologos en la toma de decisiones en su practica diaria."
           ),
           h5("Los valores de referencia para calculos y algoritmos han sido extraidos de la literatura citada."),
           h5("El contenido no trata de sustituir el criterio profesional en la toma de decisiones para el diagnostico y tratamiento."),
           h5("La utilizacion de los datos obtenidos en la app ha de ser sometida al juicio clinico y aplicada teniendo en cuenta las condiciones concretas de cada paciente."),
           h5("El autor no se responsabiliza de posibles malos usos o malentendidos derivados de la informacion aqui obtenida."),
           h5("No use esta aplicacion si no es usted un medico ginecologo especialista."),br(),
           h5("Espero sus aportaciones y comentarios en  jacostad@sego.es"),
           br(),h5("Juan Acosta. Sant Cugat Del Valles, Spain", align="right"),
           br(),br(),br(),
           p(strong("REFERENCIAS:"), align = "center"),
           p(em("IOM : guidelines on weight gain during pregnancy (2009)")),
           p(em("SEGO: Conducta expectante y Tratamiento Medico del embarazo ectopico (2014)")),
           p(em("Salomon et al., Ultrasound Obstet Gynecol. 2009 Apr")),
           p(em("Crispi et al. Progresos 2004")),
           p(em("HGC: Longitud cervical (2015)")),
           p(em("Hospital Clinic: Manejo de la paciente con riesgo de prematuridad (2015)"))
           
         )
)

 
 
))
  

