
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Параметры = Новый Структура("ВидРаботы", ПараметрКоманды);
	
	ОткрытьФорму(
		"РегистрСведений.СведенияОТочкахМаршрута.Форма.ФормаСпискаСведений", 
		Параметры,
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
