# MovieApp
Capa de persistencia:
	- CoreDataManager: se encarga de el guardado y busqueda de las peliculas disponibles en la app mediante una conexion y uso de la base de datos con CoreData

Capa de vistas: 
	- SplashVC: presentacion del logo de la app
	- ListTableVC: se encarga de la presentación del listado de peliculas en una tabla por secciones dependiendo de las peliculas
	- DetailsVC: se encarga de la presentación de los detalles de cada pelicula leseccionada por el usuario, mostrando la información mas relevante de esta

Capa de Red:
	- MoviAPI: Se encarga de la conexion y consumo de los servicios web para la obtención del listado e información de las peliculas 

Capa de Modelo de datos:
	- Sections: se encarga de la distribución de los elementos entre peliculas y categorias, para posteriormente mostrar dichos datos en la lista de peliculas
	- MovieInfo se encarga del modelado de los datos mas importantes de las peliculas


1.	En qué consiste el principio de responsabilidad única? Cuál es su propósito?

	Es el principio por el cual cada modulo del sistema tiene una unica responsabilidad sobre la funcionalidad representada mediante una clase

2.	Qué características tiene, según su opinión, un “buen” código o código limpio

	Nombres claros para las variables, la funcionalidad del codigo debe estar bien modulada, el codigo debe estar comentado donde sea necesario, y se debe dar un tratamiento a los errores mediante la implementacion de las excepciones
