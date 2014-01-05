#encoding: utf-8
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    categories = [
        'Actividad Económica',
        'Administración pública y normativa',
        'Cultura y recreación',
        'Educación',
        'Infraestructura y Obra Pública',
        'Medio Ambiente',
        'Movilidad y Transporte',
        'Salud y Servicios Sociales',
        'Seguridad',
        'Urbanismo y Territorio',
        'Legislación'
    ]

    categories.each do |category|
      c = Category.new
      c.name = category
      c.save
    end

  end
end
