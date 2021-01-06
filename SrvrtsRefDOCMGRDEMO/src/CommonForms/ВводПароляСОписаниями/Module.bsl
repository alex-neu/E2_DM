
&НаКлиенте
Процедура ОК(Команда)
	
	ВозвратПароль = Пароль;
	
	Если ПустаяСтрока(Пароль) И НЕ ПустаяСтрока(Элементы.Пароль.ТекстРедактирования) Тогда
		ВозвратПароль = Элементы.Пароль.ТекстРедактирования;
	КонецЕсли;
	
	Закрыть(ВозвратПароль);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.Заголовок;
	Файл = Параметры.Файл;
	
	Если Параметры.Свойство("ПредставленияСертификатов") Тогда
		ПредставленияСертификатов = Параметры.ПредставленияСертификатов;
	Иначе
		Элементы.ПредставленияСертификатов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
