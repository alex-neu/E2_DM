
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Адресат", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("Отбор, Заголовок, ЭтоПредставлениеВСВД", Отбор,
		НСтр("ru='Представление в СВД'"), Истина);
	
	ОткрытьФорму("РегистрСведений.УчастникиСВД.ФормаСписка", ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
