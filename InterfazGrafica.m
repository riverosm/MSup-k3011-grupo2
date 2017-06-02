pkg load control;
pkg load signal;

global pPrincipal;
global sFunciones;
global sOpciones;
global bCalcular;
global tNumPolos;
global tDenCeros;
global tGanancia;
global tFuncion;
global tResultados;
global tTitulo;
global eNumPolos;
global eDenCeros;
global eGanancia;
  
x = get(0, 'ScreenSize')
ancho = 800
alto = 600
x = [x(3)/2-(ancho/2) x(4)/2-(alto/2) ancho alto]
dialogo = dialog ("name", "TP Matemática Superior - K3011 - Grupo 2", "resize", "off");
set(dialogo, "position", x);
set(dialogo, "resize", "off");
set(dialogo, "windowstyle", "normal");
pGeneral = uipanel (dialogo, "title", "ASIC 1C 2017 - K3011 - Grupo 2", "position", [0 0 1 1]);

pPrincipal = uipanel(pGeneral, "title", "", "position", [0.024 0.025 0.95 0.85]);
set(pPrincipal, "visible", "off");
           
function ejecutar (h, e, a1)
  global sOpciones;
  global sFunciones;
  global eNumPolos;
  global eDenCeros;
  global eGanancia;
  global tResultados;
  global tTitulo;
  
  funcion = get(sFunciones, 'value');
  opcion = get(sOpciones, 'value');
  
  if (strcmp (get(eNumPolos, "string"), ""))
    errordlg ("Por favor ingrese todos los datos.");
    return;
  endif

  if (strcmp (get(eDenCeros, "string"), ""))
    errordlg ("Por favor ingrese todos los datos.");
    return;
  endif
  
  switch (opcion)
    % Coeficientes
    case 2
      valNum = str2num(get(eNumPolos, "string"));
      valDen = str2num(get(eDenCeros, "string"));
      gs = tf([valNum], [valDen]);
      [ceros,polos,ganancia]=tf2zp([valNum],[valDen]);
      ceros = num2str(ceros);
      polos = num2str(polos);
      ganancia = num2str(ganancia);
      % pzmap(gs);
      % errordlg(num2str(ceros));
    % Polos y ceros
    case 3
      if (strcmp (get(eGanancia, "string"), ""))
        errordlg ("Por favor ingrese todos los datos.");
        return;
      endif
  endswitch
  
  switch (funcion)
    case 1
      t = evalc('gs');
      set(tTitulo, "string", "    Expresión de la función");
      set(tResultados, "string", t);
      break;
    case 2
      set(tTitulo, "string", "    Polos de la función");
      set(tResultados, "string", polos);
    case 3
      set(tTitulo, "string", "    Ceros de la función");
      set(tResultados, "string", ceros);
    case 4
      set(tTitulo, "string", "    Ganancia de la función");
      set(tResultados, "string", ganancia);
    case 5
      disp(funcion);
    case 6
      disp(funcion);
    case 7
      disp(funcion);
    case 8
      disp(funcion);
    case 9
      disp(funcion);
    case 10
      exit();
  endswitch
endfunction

function cambioFuncion(h, e, a1)
  global tTitulo;
  global tResultados;
  set(tTitulo, "string","");
  set(tResultados, "string","");
endfunction

function cambioSelect(h, e, a1)
  global pPrincipal;
  global sFunciones;
  global bCalcular;
  global tNumPolos;
  global tDenCeros;
  global tGanancia;
  global eGanancia;
  global eNumPolos;
  global eDenCeros;

  set(eGanancia, "string", "");
  set(eNumPolos, "string", "");
  set(eDenCeros, "string", "");
  
  if (get ( h, 'value' ) == 3)
    set(pPrincipal, "title", "Ingrese los polos y ceros (separados por espacio) y la ganancia de la función");
    set(tGanancia, "visible", "on");
    set(eGanancia, "visible", "on");
    set(tNumPolos, "string", "Polos:");
    set(tDenCeros, "string", "Ceros:");
    set(pPrincipal, "visible", "on");
    return;
  end
  if (get ( h, 'value' ) == 2)
    set(pPrincipal, "title", "Ingrese los coeficientes del polinomio (separados por espacios Ej: x^2 + 2x + 3 = [1 2 3])  de la función");
    set(tGanancia, "visible", "off");
    set(eGanancia, "visible", "off");
    set(tNumPolos, "string", "Numerador:");
    set(tDenCeros, "string", "Denominador:");
    set(pPrincipal, "visible", "on");
    return;
  end
  set(pPrincipal, "visible", "off");
endfunction

sOpciones = uicontrol(pGeneral, "style", "popupmenu", ...
              "string","Por favor seleccione una opción ...|Ingresar coeficientes|Ingresar polos y ceros", ...
              "position", [20 alto - 60 ancho - 60 25], ...
              "callback", {@cambioSelect, "1"});

sFunciones = uicontrol(pPrincipal, "style", "popupmenu", ...
              "string","1. Expresión de la función transferencia.|2. Polos.|3. Ceros.|4. Ganancia.|5. Expresión con polos, ceros y ganancia.|6. Gráfico de polos y ceros.|7. Estabilidad del sistema.|8. Todas las características de la función.|9. Ingresar nueva función.|10. Finalizar.", ...
              "position", [460 alto - 175 ancho / 3 20], ...
              "callback", {@cambioFuncion, "1"});

bCalcular = uicontrol(pPrincipal, "style", "pushbutton", ...
               "string", "Ejecutar", ...
               "position", [20 alto - 210 ancho - 90 25], ...
               "callback", {@ejecutar, "1"});
               
tNumPolos = uicontrol(pPrincipal, "style", "text", ...
              "string","Numerador", ...
              "position", [20 alto - 145 ancho / 10 20], ...
              "horizontalalignment","left");

tDenCeros = uicontrol(pPrincipal, "style", "text", ...
              "string","Denominador", ...
              "position", [20 alto - 175 ancho / 10 20], ...
              "horizontalalignment","left");
              
tGanancia = uicontrol(pPrincipal, "style", "text", ...
              "string","Ganancia:", ...
              "position", [370 alto - 145 ancho / 10 20], ...
              "horizontalalignment","left");
              
tFuncion = uicontrol(pPrincipal, "style", "text", ...
              "string","Obtener:", ...
              "position", [370 alto - 175 ancho / 10 20], ...
              "horizontalalignment","left");

eNumPolos = uicontrol(pPrincipal, "style", "edit", ...
              "string","", ...
              "position", [160 alto - 145 ancho / 5 20], ...
              "horizontalalignment","left");
              
eDenCeros = uicontrol(pPrincipal, "style", "edit", ...
              "string","", ...
              "position", [160 alto - 175 ancho / 5 20], ...
              "horizontalalignment","left");
              
eGanancia = uicontrol(pPrincipal, "style", "edit", ...
              "string","", ...
              "position", [460 alto - 145 ancho / 3 20], ...
              "horizontalalignment","left");

tTitulo = uicontrol(pPrincipal, "style", "text", ...
              "string","", ...
              "position", [20 alto - 250 ancho - 90 30], ...
              "fontsize", 20,
              "fontweight", "bold",
              "verticalalignment", "top",
              "horizontalalignment","left");
              
tResultados = uicontrol(pPrincipal, "style", "text", ...
              "string","", ...
              "position", [20 alto - 550 ancho - 90 300], ...
              "fontsize", 14,
              "fontweight", "bold",
              "verticalalignment", "middle",
              "horizontalalignment","center");