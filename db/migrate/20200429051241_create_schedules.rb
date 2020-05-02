class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    def change
      create_table :schedules do |t|
        t.date :date
        t.time :from
        t.time :until
        t.string :todo
        t.string :category
        t.text :memo
      end
    end
  end
end
