require '../../config/environment'

indicator_labels = ["i1", "i2", "i3", "i4", "i5", "i6", "i7", "i8"]
descriptions = ["utilizzo farmaco generico", "interruzione della cura", "importanza della segnalazione", "carico dei farmaci",
                "consapevolezza degli effetti indesiderati", "automedicazione", "costo dei farmaci/spreco", "modifica volume del farmaco", 
                  "importanza foglietto illustrativo", "consapevolezza della semplificazione dei foglietti illustrativi", "attenzione verso le indicazioni del foglietto illustrativo"]
                

### Loading description to database

0.upto(indicator_labels.length - 1) do |n|
    indicator = IndicatorDescription.new(name: indicator_labels[n], description: descriptions[n])
    indicator.save
#    binding.pry
end    