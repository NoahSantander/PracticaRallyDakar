ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).
pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

% 1.a
modelo(peugeot, 2008).
modelo(peugeot, 3008).
modelo(mini, countryman).
modelo(volkswagen, touareg).
modelo(toyota, hilux).
modelo(mini, buggy).

% 1.b
% Solamente es necesario agregar que el modelo buggy es marca Mini, ya que por Principio de Universo Cerrado, dkr no es marca Mini

% 2
% ganadorReincidente/2 Competidor que gano en mas de un año
ganadorReincidente(Ganador):-
    ganador(Year1, Ganador, _),
    ganador(Year2, Ganador, _),
    Year1 \= Year2.

% 3
% inspiraA/2 Un conductor resulta inspirador para otro de su mismo país cuando ganó y el otro no, o si ganó el año pasado y el otro no
inspiraA(Inspirador, Inspirado):-
    ganador(Year, Inspirador, _),
    pais(Inspirador, Pais),
    pais(Inspirado, Pais),
    not(ganador(Year, Inspirado, _)),
    Inspirado \= Inspirador.

inspiraA(Inspirador, Inspirado):-
    ganador(Year1, Inspirado, _),
    pais(Inspirado, Pais),
    pais(Inspirador, Pais),
    ganador(Year2, Inspirador, _),
    Year1 > Year2,
    Inspirado \= Inspirador.

% 4
% obtenerMarcaVehiculo/2 Relaciona un vehiculo con su marca
obtenerMarcaVehiculo(auto(Modelo), Marca):-
    modelo(Marca, Modelo).

obtenerMarcaVehiculo(moto(Year, _), ktm):-
    Year > 1999.

obtenerMarcaVehiculo(moto(Year, _), yamaha):-
    Year < 2000.

obtenerMarcaVehiculo(camion(Cosas), kamaz):-
    member(vodka, Cosas).

obtenerMarcaVehiculo(camion(Cosas), iveco):-
    not(member(vodka, Cosas)).

obtenerMarcaVehiculo(cuatri(Marca), Marca).

% marcaDeLaFortuna/2 Relaciona un conductor con una marca si sólo ganó con vehículos de esa marca
ganoConDistintaMarca(Ganador, Vehiculo1, Marca1):-
    ganador(_, Ganador, Vehiculo1),
    obtenerMarcaVehiculo(Vehiculo1, Marca1),
    ganador(_, Ganador, Vehiculo2),
    obtenerMarcaVehiculo(Vehiculo2, Marca2),
    Marca1 \= Marca2.

marcaDeLaFortuna(Conductor, Marca):-
    ganador(_, Conductor,_),
    forall(ganador(_, Conductor, Vehiculo),not(ganoConDistintaMarca(Conductor, Vehiculo, Marca))).

% 5
% heroePopular/1 Un corredor es un héroe popular cuando sirvió de inspiración a alguien, y además el año que salió ganador fue el único de los conductores ganadores que no usó un vehículo caro
marcaCara(iveco).
marcaCara(mini).
marcaCara(toyota).

esMarcaCara(Vehiculo):-
    obtenerMarcaVehiculo(Vehiculo, Marca),
    marcaCara(Marca).

esMarcaCara(moto(_, Suspensiones)):-
    Suspensiones > 2.

esMarcaCara(cuatri(_)).

ganadorDiferente(Ganador, Year, VehiculoCompetidor):-
    ganador(Year, Ganador, VehiculoCompetidor),
    ganador(Year, Ganador1, _),
    Ganador \= Ganador1.

heroePopular(Conductor):-
    inspiraA(Conductor, _),
    ganador(Year, Conductor, Vehiculo),
    not(esMarcaCara(Vehiculo)),
    forall(ganadorDiferente(Conductor, Year, VehiculoCompetidor), esMarcaCara(VehiculoCompetidor)). % Para cada ganador diferente al heroe, su vehiculo tiene que ser caro

% 6.a
etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

calcularDistancia(Localizacion1, Localizacion2, Distancia):-
    Localizacion1 \= Localizacion2,
    etapa(Localizacion1, Localizacion2, Distancia).

calcularDistancia(Localizacion1, Localizacion2, Distancia):-
    Localizacion1 \= Localizacion2,
    etapa(Localizacion1, LocalizacionSiguiente, DistanciaActual),
    calcularDistancia(LocalizacionSiguiente, Localizacion2, DistanciaSiguiente),
    Distancia is DistanciaActual + DistanciaSiguiente.

% 6.b
recorrerDistancia(Vehiculo, Distancia):-
    esMarcaCara(Vehiculo),
    Distancia < 2000.

recorrerDistancia(Vehiculo, Distancia):-
    not(esMarcaCara(Vehiculo)),
    Distancia < 1800.


