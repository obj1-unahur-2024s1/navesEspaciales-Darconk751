class NaveEspacial {
	var velocidad
	var direccion
	var cantidadDeCombustible
	
	method velocidad() = velocidad
	method direccion() = direccion
	method cantidadDeCombustible() = cantidadDeCombustible
	method acelerar(cuanto){
		velocidad = 100000.min(velocidad + cuanto)
	}
	method desacelerar(cuanto){
		velocidad = 0.max(velocidad - cuanto)
	}
	method irHaciaElSol(){
		direccion = 10
	}
	method escaparDelSol(){
		direccion = -10
	}
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion + 1)
	}
	method alejarseUnPocoDelSol(){
		direccion = -10.max(direccion - 1)
	}
	method cargarCombustible(cantidad){
		cantidadDeCombustible = cantidadDeCombustible + cantidad 
	}
	method descargarCombustible(cantidad){
		cantidadDeCombustible = 0.max(cantidadDeCombustible - cantidad)
	}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila() = self.cantidadDeCombustible() >= 4000 and self.velocidad() <= 12000 and self.condicionDeTranquilidadAdicional()
	method condicionDeTranquilidadAdicional() /*metodo abstracto*/
	method escapar() /*metodo abstracto */
	method avisar() /*metodo abstracto*/
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method tienePocaActividad() /*metodo abstracto */
	method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza 
	var cambioDeColor = false
	method colorBaliza() = colorBaliza
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioDeColor = true
	}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method condicionDeTranquilidadAdicional() = self.colorBaliza() != "rojo"
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	override method tienePocaActividad() = not cambioDeColor
}

class NavePasajero inherits NaveEspacial {
	const cantidadDePasajeros 
	var cantidadDeRacionesDeComida = 0
	var cantidadDeBebidas = 0
	var racionesDeComidasServidas = 0
	
	method racionesDeComidasServidas() = racionesDeComidasServidas
	method cantidadDeRacionesDeComida() = cantidadDeRacionesDeComida
	method cantidadDeBebidas() = cantidadDeBebidas
	method cantidadDePasajeros() = cantidadDePasajeros 
	method cargarRacionDeComida(unaCantidad){
		cantidadDeRacionesDeComida = cantidadDeRacionesDeComida + unaCantidad
	}
	method descargarRacionDeComida(unaCantidad){
		cantidadDeRacionesDeComida = cantidadDeRacionesDeComida - unaCantidad
	}
	
	method cargarRacionDeBebida(unaCantidad){
		cantidadDeBebidas = cantidadDeBebidas + unaCantidad
	}
	
	method descargarRacionDeBebida(unaCantidad){
		cantidadDeRacionesDeComida = cantidadDeRacionesDeComida - unaCantidad
	}
	override method prepararViaje(){
		super()
		self.cargarRacionDeComida(4 * cantidadDePasajeros)
		self.cargarRacionDeBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	override method condicionDeTranquilidadAdicional() = true
	method servirComida(cantidad){
		racionesDeComidasServidas += cantidadDeRacionesDeComida.min(cantidad)
		self.descargarRacionDeComida(cantidad)
	}
	override method escapar(){
		self.acelerar(velocidad)
	}
	override method avisar(){
		self.servirComida(cantidadDePasajeros)
		self.descargarRacionDeBebida(cantidadDePasajeros * 2)
	}
	override method tienePocaActividad() = self.racionesDeComidasServidas() < 50
}

class NaveDeCombate inherits NaveEspacial {
	var esVisible = false
	var misilesDesplegados = true
	const mensajesEmitidos = []
	
	method ponerseVisible(){
		esVisible = false
	}
	method ponerseInvisible(){
		esVisible = true
	}
	method estaInvisible() = not esVisible
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	method replegarMisiles(){
		misilesDesplegados = false
	}
	method misilesDesplegados() = misilesDesplegados
	method emitirMensaje(mensaje){
		mensajesEmitidos.add(mensaje)
	}
	method mensajesEmitidos() = mensajesEmitidos
	method primerMensajeEmitido() = mensajesEmitidos.first()
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	method esEscueta() = ! mensajesEmitidos.any({mensaje => mensaje.size() > 30})
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
	override method prepararViaje(){
		super()
		self.acelerar(15000)
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en misión")
	}
	override method condicionDeTranquilidadAdicional() = not self.misilesDesplegados()
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad() = self.esEscueta()
}

class NaveHospital inherits NavePasajero {
	var quirofanosEstanPreparados = false
	method quirofanosEstanPreparados() = quirofanosEstanPreparados
	method prepararQuirofanos(){
		quirofanosEstanPreparados = true
	}
	method noPrepararQuirofanos(){
		quirofanosEstanPreparados = false
	}
	override method condicionDeTranquilidadAdicional() = not self.quirofanosEstanPreparados()
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
}

class NaveDeCombateSigiloso inherits NaveDeCombate{
	override method condicionDeTranquilidadAdicional() = super() and not self.estaInvisible()
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}
