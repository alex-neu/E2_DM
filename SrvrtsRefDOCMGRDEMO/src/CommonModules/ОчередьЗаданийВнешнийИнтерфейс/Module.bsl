// @strict-types

#Область ПрограммныйИнтерфейс

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	Обработчики - ТаблицаЗначений - таблица обработчиков.
//				- см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки
// 
// Параметры:
//	Типы - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.СвойстваЗаданий);
	
КонецПроцедуры

#КонецОбласти 
