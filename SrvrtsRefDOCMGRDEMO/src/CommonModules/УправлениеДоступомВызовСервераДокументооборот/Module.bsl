
Процедура ПриИзмененииСоставаСотрудниковПодразделения(Подразделение) Экспорт
	
	ЗаполнитьПодчиненностьПользователейПоПодразделению(Подразделение);
	
	ЗаполнитьСоставСотрудниковРодительскихПодразделений(Подразделение.Родитель);
	
КонецПроцедуры	

Процедура ЗаполнитьСоставСотрудниковРодительскихПодразделений(РодительскоеПодразделение) Экспорт
	
	ТекущийРодитель = РодительскоеПодразделение;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		ЗаполнитьПодчиненностьПользователейПоПодразделению(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла;
	
КонецПроцедуры	

Процедура ЗаполнитьПодчиненностьПользователейПоПодразделению(Подразделение) Экспорт
	
	// Очистка старых записей
	НаборЗаписей = РегистрыСведений.ПодчиненностьСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Подразделение.Установить(Подразделение);
	НаборЗаписей.Записать();
	
	Если Подразделение.Руководитель.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПодчиненностьСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Подразделение.Установить(Подразделение);
	
	// Собираем пользователей данного и подчиненных подразделений
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОПользователяхДокументооборот.Пользователь
		|ИЗ
		|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|ГДЕ
		|	СведенияОПользователяхДокументооборот.Подразделение В ИЕРАРХИИ (&Подразделение)";
	Запрос.УстановитьПараметр("Подразделение", Подразделение);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Запись = НаборЗаписей.Добавить();
		Запись.Руководитель = Подразделение.Руководитель;
		Запись.Подчиненный = Выборка.Пользователь;
		Запись.Подразделение = Подразделение;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьПодчиненностьПользователей() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка,
		|	СтруктураПредприятия.Руководитель
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Руководитель.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьПодчиненностьПользователейПоПодразделению(Выборка.Ссылка);
	КонецЦикла;

КонецПроцедуры	

//Проверяет доступность ссылки текущему пользователю
Функция СсылкаДоступнаТекущемуПользователю(Ссылка) Экспорт
	
	Если Ссылка = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапросДоступности = Новый Запрос;
	ЗапросДоступности.Текст = 
		"Выбрать РАЗРЕШЕННЫЕ
		|	Объекты.Ссылка
		|ИЗ <МетаданныеСсылка> КАК Объекты
		|ГДЕ
		|	Объекты.Ссылка = &Ссылка";
	УстановитьПривилегированныйРежим(Истина);
	ЗапросДоступности.Текст = СтрЗаменить(ЗапросДоступности.Текст, "<МетаданныеСсылка>", Ссылка.Метаданные().ПолноеИмя());
	УстановитьПривилегированныйРежим(Ложь);
	ЗапросДоступности.УстановитьПараметр("Ссылка", Ссылка);
	Возврат НЕ ЗапросДоступности.Выполнить().Пустой();
	
КонецФункции