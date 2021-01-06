
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли; 
	
	Если Параметры.Свойство("Родитель")
		И ТипЗнч(Параметры.Родитель) = Тип("СправочникСсылка.ГруппыЛичныхАдресатов") Тогда
		
		Объект.Родитель = Параметры.Родитель;
	КонецЕсли;
	
КонецПроцедуры
