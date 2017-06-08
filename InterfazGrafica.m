pkg load control;
pkg load signal;

%Variables globales
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

%Configuraciones de pantalla
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

%Funcion ejecutar
function ejecutar (h, e, a1)
  global pPrincipal;
  global sOpciones;
  global sFunciones;
  global eNumPolos;
  global eDenCeros;
  global eGanancia;
  global tResultados;
  global tTitulo;
  
  funcion = get(sFunciones, 'value'); % 2 = ingreso por coeficientes | 3 = ingreso por polos y ceros
  opcion = get(sOpciones, 'value'); % 1 = expresion de la func transf | 2 = Polos | 3 = Ceros | 4 = Ganancia | ...
 
  %chequeo que no haya ingresado campos vacios
  if (strcmp (get(eNumPolos, "string"), "") && funcion != 9 && funcion != 10)
    errordlg ("Por favor ingrese todos los datos.");
    return;
  endif

  if (strcmp (get(eDenCeros, "string"), "") && funcion != 9 && funcion != 10)
    errordlg ("Por favor ingrese todos los datos.");
    return;
  endif
  
  %obtengo los datos segun la opcion que ingreso (coeficientes o polos/ceros)
  switch (opcion)
    % Coeficientes
    case 2
      valNum = str2num(get(eNumPolos, "string"));
      valDen = str2num(get(eDenCeros, "string"));
      %tf recibe los numeradores y denominadores y arma la funcion transferencia
      gs = tf([valNum], [valDen]);
      %tf2zp recibe la funcion transferencia (variable gs) y te la devuelve en expresiones de ceros, polos y ganancia
      [ceros,polos,ganancia]=tf2zp([valNum],[valDen]);      
      % pzmap(gs);
      % errordlg(num2str(ceros));
      
    % Polos y ceros
    case 3
      if (strcmp (get(eGanancia, "string"), "") && funcion != 9 && funcion != 10)
        errordlg ("Por favor ingrese todos los datos.");
        return;
      endif
      ceros = str2num(get(eDenCeros, "string"));
      polos = str2num(get(eNumPolos, "string"));
      ganancia = str2num(get(eGanancia, "string"));
      gs = zpk(ceros, polos, ganancia)
      
  endswitch
  
  polosReales = setdiff(polos, ceros);
  cerosReales = setdiff(ceros, polos);
  
  % Deshabilito todo para después habilitarlo con el "Ingresar nueva función"
  set(sOpciones, "enable", "off");
  set(eGanancia, "enable", "off");
  set(eNumPolos, "enable", "off");
  set(eDenCeros, "enable", "off");
  set(tResultados, "horizontalalignment","center");
  
%muestro los resultados segun la funcionalidad que se selecciono  
  switch (funcion)
    case 1
      t = evalc('gs');
      t = substr(t, 56, strfind(t, "Contin") - 57);
      set(tTitulo, "string", "    Expresión de la función");
      set(tResultados, "string", t);
      break;
    case 2
      set(tTitulo, "string", "    Polos de la función");
      set(tResultados, "string", num2str(polosReales));
      break;
    case 3
      set(tTitulo, "string", "    Ceros de la función");
      set(tResultados, "string", num2str(cerosReales));
      break;
    case 4
      set(tTitulo, "string", "    Ganancia de la función");
      set(tResultados, "string", num2str(ganancia));
      break;
    case 5
       t = evalc('gs');
       t = substr(t, 56, strfind(t, "Contin") - 57);
      set(tTitulo, "string", "    Expresión de la función");
      set(tResultados, "string", t);
    case 6
        set(tTitulo, "string", "    Gráfico de polos y ceros");
        fPolosCeros = figure(1, "visible", "off");
        x = get(0, 'ScreenSize')
        x = [x(3)/2-(300/2) x(4)/2.9-(300/2) 300 300]
        set(fPolosCeros, "position", x);
        set(fPolosCeros, "menubar", "none");
        set(fPolosCeros, "windowstyle", "modal");
        set(fPolosCeros, "name", "Gráfico de polos y ceros");
        set(fPolosCeros, "resize", "off");
        set(fPolosCeros, "visible", "on");
        zplane(cerosReales, polosReales);
    case 7
      % Estabilidad de sistema
      set(tTitulo, "string", "    Estabilidad del sistema");
      set(tResultados, "horizontalalignment","left");
      
      stringPolos = "";
      polosPositivos = 0;
      polosNulos = 0;
      % Me fijo los polos
      for i = 1:length(polosReales)
        stringPolos = [stringPolos "Parte real polo " num2str(i) ": " num2str(real(polosReales(i))) "\n"];
        if (real(polosReales(i)) > 0)
          polosPositivos++;
        endif
        if (real(polosReales(i)) == 0)
          polosNulos++;
        endif
      endfor
      
      if (polosPositivos != 0)
        stringPolos = [stringPolos "\n\n Hay " num2str(polosPositivos) " polos con parte real positiva\n" ...
                        "\t\t\t\tSISTEMA INESTABLE"];
      elseif (polosNulos == 0)
        stringPolos = [stringPolos "\t\t\t\tSISTEMA ESTABLE"];
      elseif (polosNulos == 1)
        stringPolos = [stringPolos "\t\t\tSISTEMA MARGINALMENTE ESTABLE"];
      elseif (polosNulos > 1)
        stringPolos = [stringPolos "\t\t\tSISTEMA INESTABLE (" num2str(polosNulos) " polos en el cero)"];
      endif
       
      set(tResultados, "string", stringPolos);
      
    case 8
      % Todas las características
      set(tTitulo, "string", "    Todas las características de la función");
      
            stringPolos = "";
      polosPositivos = 0;
      polosNulos = 0;
      % Me fijo los polos
      for i = 1:length(polosReales)
        if (real(polosReales(i)) > 0)
          polosPositivos++;
        endif
        if (real(polosReales(i)) == 0)
          polosNulos++;
        endif
      endfor
      
      if (polosPositivos != 0)
        stringPolos = [stringPolos "\t\t\t\tSISTEMA INESTABLE"];
      elseif (polosNulos == 0)
        stringPolos = [stringPolos "\t\t\t\tSISTEMA ESTABLE"];
      elseif (polosNulos == 1)
        stringPolos = [stringPolos "\t\t\tSISTEMA MARGINALMENTE ESTABLE"];
      elseif (polosNulos > 1)
        stringPolos = [stringPolos "\t\t\tSISTEMA INESTABLE (" num2str(polosNulos) " polos en el cero)"];
      endif
      
      t = evalc('gs');
      t = substr(t, 56, strfind(t, "Contin") - 57);
      set(tResultados, "horizontalalignment","left");
      set(tResultados, "string", ["\nExpresión:\n\n" t ...
          "\n- Polos:\t\t" num2str(polosReales) ...          
          "\n- Ceros:\t\t" num2str(cerosReales) ...
          "\n- Ganancia:\t" num2str(ganancia) ...
          "\n- Estabilidad:\t" stringPolos ...
          ]);
      
      fPolosCeros = figure(1, "visible", "off");
      x = get(0, 'ScreenSize')
      x = [x(3)/1.50-(200/2) x(4)/3-(200/2) 200 200]
      set(fPolosCeros, "position", x);
      set(fPolosCeros, "menubar", "none");
      set(fPolosCeros, "windowstyle", "modal");
      set(fPolosCeros, "name", "Gráfico");
      set(fPolosCeros, "resize", "off");
      set(fPolosCeros, "visible", "on");
      zplane(cerosReales, polosReales);
      
      disp(funcion);
    case 9
      set(sOpciones, "enable", "on");
      set(eGanancia, "enable", "on");
      set(eNumPolos, "enable", "on");
      set(eDenCeros, "enable", "on");
      set(sOpciones, "value", 1);
      set(sFunciones, "value", 1);
      set(pPrincipal, "visible", "off");
    case 10
      close();
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
  set(sFunciones, "value", 1);
  
  %Si selecciono la opcion "INGRESAR POLOS Y CEROS" seteo los strings correspondientes
  if (get ( h, 'value' ) == 3)
    set(pPrincipal, "title", "Ingrese los polos y ceros (separados por espacio) y la ganancia de la función");
    set(tGanancia, "visible", "on");
    set(eGanancia, "visible", "on");
    set(tNumPolos, "string", "Polos:");
    set(tDenCeros, "string", "Ceros:");
    set(pPrincipal, "visible", "on");
    return;
  end
  
  %Si selecciono la opcion "INGRESAR COEFICIENTES" seteo los strings correspondientes
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


%Controles de la UI
% 1) Dropdown de opciones, cuando se cambia la opcion llama a la funcion cambioSelect 
sOpciones = uicontrol(pGeneral, "style", "popupmenu", ...
              "string","Por favor seleccione una opción ...|Ingresar coeficientes|Ingresar polos y ceros", ...
              "position", [20 alto - 60 ancho - 60 25], ...
              "callback", {@cambioSelect, "1"});
              
% 2) Dropdown de funcionalidades, cuando se cambia la opcion llama a cambioFuncion
sFunciones = uicontrol(pPrincipal, "style", "popupmenu", ...
              "string","1. Expresión de la función transferencia.|2. Polos.|3. Ceros.|4. Ganancia.|5. Expresión con polos, ceros y ganancia.|6. Gráfico de polos y ceros.|7. Estabilidad del sistema.|8. Todas las características de la función.|9. Ingresar nueva función.|10. Finalizar.", ...
              "position", [460 alto - 175 ancho / 3 20], ...
              "callback", {@cambioFuncion, "1"});
              
% 3) Boton que ejecuta las operaciones, llama a ejecutar
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