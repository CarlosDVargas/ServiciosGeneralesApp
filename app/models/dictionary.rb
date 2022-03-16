class Dictionary
  attr_reader :requesterTypes, :workBuildings, :workTypes, :studentAssociations

  def initialize
    @requesterTypes = { teacher: "Docente", administrator: "Administativo", student: "Estudiante" }
    @studentAssociations = { assosiation: "Asociación Estudiantil", feucr: "FEUCR" }
    @workBuildings = { gym: "Gimnasio", sciencie_labs: "Laboratiorios Ciencias Generales", cafeteria: "Comedor", other: "Otro" }
    @workTypes = { electrical: "Eléctrico", plumbing: "Plomería", wood: "Ebanistería", other: "Otro" }
  end
end
