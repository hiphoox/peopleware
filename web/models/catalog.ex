defmodule Peopleware.Catalog do
  #####################
  # Catalogs
  #####################

  # For searching we need to set the empty string as the default value 
  def search_contractings, do: [""| contractings]
  def search_idiom_levels, do: [""| idiom_levels]
  def search_option_levels, do: [""| option_levels]
  def search_states, do: [""| states]
  def search_roles, do: [""| roles]

  def contractings do
    ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"]
  end

  def idiom_levels do
    ["No", "Basico", "intermedio", "avanzado"]
  end

  def option_levels do
    ["No", "Si", "Tal vez"]
  end

  def states do
    ["Distrito Federal",
     "Aguascalientes",
     "Baja California",
     "Campeche",
     "Coahuila",
     "Colima",
     "Chiapas",
     "Chihuahua",
     "Durango",
     "Guanajuato",
     "Guerrero",
     "Hidalgo",
     "Jalisco",
     "Estado de México",
     "Michoacán",
     "Morelos",
     "Nayarit",
     "Nuevo León",
     "Oaxaca",
     "Puebla",
     "Querétaro",
     "Quintana Roo",
     "San Luis Potosí",
     "Sinaloa",
     "Sonora",
     "Tabasco",
     "Tamaulipas",
     "Tlaxcala",
     "Veracruz",
     "Yucatán",
     "Zacatecas",
     "Extranjero"]
  end

  def roles do
    ["Otro",
     "Desarrollador",
     "Analista de negocio",
     "Analista de procesos",
     "Analista programador",
     "Arquitecto de aplicaciones",
     "Arquitecto de soluciones",
     "Business Intelligence",
     "Comunicaciones",
     "Director",
     "DBA",
     "EBS Funcional",
     "EBS developer",
     "Gerente",
     "Ingeniero de seguridad",
     "Líder de proyecto",
     "Operador",
     "Project manager",
     "Quality assurance",
     "SAP developer",
     "SAP funcional",
     "Soporte a infraestructura",
     "Soporte técnico",
     "Tester",
     "Ventas"]
  end
end
