#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#


library(shiny)


 
shinyServer(function(input, output,session) {
   
  
  
  #fechas de cervix
  n1<-reactive({Sys.Date()-input$lmd})
  weeks<-reactive({as.integer(n1()/7)})
  predays<-reactive({(n1()/7)-weeks()})
  days<-reactive({as.integer(predays()*7)})
  output$messageweeks<-renderText(paste("Gestacion de : ",weeks(),"Semanas",days(),"dias"))
  
  
  #Cervix
  basecervix<-read.csv("cuello.csv",sep=";")
   
  
  #cervix,,,,boton borrar
  observe({input$borrar
               updateNumericInput(session,"lcx", val=25)
               updateRadioButtons(session,"pretermino",selected="no")
               updateRadioButtons(session,"incompetencia",selected="no")
               updateRadioButtons(session,"unaincompetencia",selected="no")
               updateRadioButtons(session,"perdidas",selected="0")
               updateRadioButtons(session,"conos",selected="no")
               updateRadioButtons(session,"pret",selected="no")
               updateRadioButtons(session,"acortamiento",selected="no")
               updateRadioButtons(session,"otros",selected="no")
               updateRadioButtons(session,"incierto",selected="no")
               })
  
  #escogiendo el percentil 5 del valor de Longitud cervical
   
  dataprecervix1<-reactive({as.numeric(paste(basecervix[which(basecervix$semanas==weeks()),4]))})
  output$TESTANDO<-renderText(paste("percentil 5 (Salomon et al.): ",dataprecervix1(),"."))
  resulcuello<-reactive({if(input$lcx<dataprecervix1()) {"Longitud cervical < percentil 5"}else {"Longitud cervical >p5"}})
  resulcuello2<-reactive({if(input$lcx<25) {"Alto riesgo"}  else {"Bajo riesgo"}})
  
  asintcuellocorto<-reactive({ if (input$lcx<20 &   input$incompetencia=="no" & input$conos=="no" & input$perdidas=="0" & input$pret=="no" & input$otros=="no" & input$acortamiento=="no"){1} else {0} })
  
  comentario<-reactive({if (input$acortamiento=="si"){"Ofrecer cerclaje terapeutico"} else{"controles por su ginecologo "}})
  com1<-renderText(paste("Conducta: ",comentario()))
 
  #definicion de las diferentes situaciones especiales
  riesgoa<-reactive({ if (input$perdidas=="3" |(input$perdidas=="2"& input$incompetencia=="si") ){1} else {0}})
  riesgob<-reactive({if ((input$perdidas=="2"&input$incompetencia=="no")&input$lcx<25){1}else{0}  })
  riesgoc<-reactive({if(input$pretermino=="no" & input$lcx<20){1}else{0}})
  riesgod<-reactive({if ( input$acortamiento=="si" & input$lcx<25 ){1}else{0}})
  riesgoe<-reactive({if( input$lcx<25 & (input$incompetencia=="no" &(input$perdidas=="2"|input$perdidas=="1")) ){1}else{0}})
  riesgof<-reactive({ if( input$lcx<25 & input$pretermino=="si" ){1}else{0} })
  riesgog<-reactive({if( input$perdidas!="0"& input$conos=="si" ){1}else{0}}) 
  riesgopotencial<-reactive({if ( input$perdidas!="0" | input$otros=="si" | input$incierto=="si"| input$pretermino=="si"| input$unaincompetencia=="si" ){1}else{0}})
  #definicion del algoritmo
   algoritmo<-reactive({ if(riesgoa()==1 & riesgod()==0  ){1} 
    else if (riesgob()==1 & (riesgod()==0 & riesgog()==0)){2}
    else if (riesgoe()==1 & riesgod()==0 & riesgog()==0){2}
    else if ( riesgof()==1 & riesgod()==0){2}
    else if(riesgoc()==1& riesgod()==0){3}
    else if ( riesgog()==1 & riesgod()==0){1} 
    else if (riesgopotencial()==1 & input$lcx>=25 &  riesgod()==0 & riesgob()==0 & riesgog()==0){5} 
    else if (riesgopotencial()==1 & input$lcx<25 & riesgod()==0 ){2}
     else if(riesgod()==1){4}
                           
    else {6}})
   
  mensajealgoritmo<-reactive({if  (algoritmo()==1 ){"Ofrecer cerclaje cervical profilactico entre las 13-16 semanas"} 
    else if (algoritmo()==2) {"Ofrecer Progesterona vaginal 200mg/noche"}
    else if (algoritmo()==3){"Ofrecer Progesterona vaginal 200mg/noche"}
    else if (algoritmo()==4){"Ofrecer cerclaje terapeutico"}
    else if(algoritmo()==5){"Seguimiento y medicion cervical cada 2 semanas"}
    else {"Seguimiento habitual"}}) 
  
  
  

 output$algoritmoprint<-renderText(paste(" ",mensajealgoritmo()))
  
  cuelloprint<-reactive({if(weeks()<12|weeks()>36){"Semanas fuera de rango"}else {resulcuello()}})
  output$APP<-renderText(cuelloprint()) 
  output$APP2<-renderText(resulcuello2()) 
  
  
  
  
  ## GEMELARES
  
  basegem<-read.csv("riesgotwins.csv",sep=";",dec=",")
  fila<-reactive({ if (input$lcx2<15 ){1} 
    else if (input$lcx2<20){2}
    else if (input$lcx2<25){3}
    else if (input$lcx2<30){4}
    else {5}
    })
  semt<-reactive({as.numeric(input$sem2)})
  riesgot1<-reactive({(as.double(paste(basegem[ fila(),2])))})
  riesgot2<-reactive({(as.numeric(paste(basegem[ fila(),3])))})
  riesgot3<-reactive({(as.numeric(paste(basegem[ fila(),4])))})
  riesgot4<-reactive({(as.numeric(paste(basegem[ fila(),5])))})
  output$riskt1<-renderText(paste("Riesgo parto< 28 semanas: ",riesgot1(),"%"))
  output$riskt2<-renderText(paste("Riesgo parto< 30 semanas: ",riesgot2(),"%"))
  output$riskt3<-renderText(paste("Riesgo parto< 32 semanas: ",riesgot3(),"%"))
  output$riskt4<-renderText(paste("Riesgo parto< 34 semanas: ",riesgot4(),"%"))
  
  gradolcx2<-reactive({if(input$lcx2>=25  ){1}
    else if (input$lcx2<25 & input$lcx2>=10){2}
    else {3}
    })
   
  resultwin<-reactive({if (gradolcx2()==1){1}
    else if (gradolcx2()==2 | (gradolcx2()==3& input$sem2>=26)){2}
    else {3}
    })
  
  consejos<-reactive({ if (resultwin()==1 & input$prolapso=="no"){"Seguimiento habitual"}
    else if ( resultwin()==2 & input$prolapso=="no"){"Se podria plantear tratamiento con Progesterona vaginal 200mg/d"}
    else if (input$prolapso=="si"){"Ingreso, perfusion de antibioticos. Valorar cerclaje"}
    else {"Valorar ingreso. Extremar controles"}
    })
  
  diagnt<-reactive({ if (gradolcx2()==1 & input$prolapso=="no"){"Bajo Riesgo"}
    else    {"Alto riesgo" }
     
  })
  
  percentil<-reactive({as.numeric(paste(basecervix[which(basecervix$semanas==semt()),5]))})
  
  output$consejost<-renderText(paste(consejos()))
  output$consejost2<-renderText(paste(diagnt()))
  
  output$pctwin<-renderText(paste("percentil 5 (Crispi et al, 2004): ",percentil()))
 
  output$otrosfactores<-renderUI({
    strcervix<-paste(h6(em("* miomas, malformaciones uterinas, traquelectomia,tabaquismo, IMC<19, edad extrema...")))
    HTML(paste(strcervix))}
  )
  
  output$consideracionest<-renderUI({
    consi1<-paste(h6("- No administrar Corticoides ambulatorios fuera del contexto de ingreso de la paciente"))
    consi2<-paste(h6("- Aunque la progesterona no ha demostrado ser util en las gestaciones gemelares un reciente metanalisis mostro una tendencia al parto<33 semanas en pacientes con cervix<25 que habian recibido progesterona vs. grupo control"))
    consi3<-paste(h6("- No existe evidencia sobre la utilidad del cerclaje en gestaciones gemelares y en algun estudio se ha demostrado que puede empeorar el resultado perinatal."))
    consi4<-paste(h6("- El reposo estricto en cama no ha demostrado disminuir la prematuridad en embarazos unicos ni en gemelares. Al contrario puede aumentar el riesgo de tromboembolismo, osteoporosis y disminucion de la masa muscular materna."))
    HTML(paste(consi1,consi2,consi3,consi4))}
  )
  
  
   })
  
  
  
  


