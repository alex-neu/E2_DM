////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с чат-ботом (сервер, повторное использование).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограмныйИнтерфейс

// Проверяет есть ли активные состояния чат-бота
//
// Возвращаемое значение:
//  Булево - Истина, если есть хотя бы одно состояние чат-бота активировано.
//
Функция ЕстьАктивныеСостояния() Экспорт
	
	Если РаботаСЧатБотом.ЭтоАдминистраторЧатБота() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Справочник.СостоянияЧатБота КАК СостоянияЧатБота
		|ГДЕ
		|	СостоянияЧатБота.Используется
		|	И НЕ СостоянияЧатБота.ПометкаУдаления
		|	И НЕ СостоянияЧатБота.Предопределенный";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции 

// Проверяет используется ли чат-бот
//
// Возвращаемое значени:
//  Булево - Истина, если ИспользоватьЧатБота = Истина.
Функция ЧатБотИспользуется() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	ЧатБотИспользуется = Константы.ИспользоватьЧатБота.Получить();
	
	Возврат ЧатБотИспользуется;

КонецФункции

// Определяет, какой пользователь назначен чат-ботом.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - Пользователь, назначенный чат-ботом.
//
Функция ЧатБот() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	ЧатБот = Константы.ЧатБот.Получить();
	
	Возврат ЧатБот;

КонецФункции

// Возвращает идентификатор пользователя чат-бота в Системе взаимодействия.
//
// Возвращаемое значение:
//  ИдентификаторПользователяСистемыВзаимодействия - Идентификатор чат-бота в
//    системе взаимодействия
//
Функция ИДентификаторБотаСВ() Экспорт
	
	ЧатБот = ЧатБот();
	
	Возврат ОбсужденияДокументооборот.ИдентификаторПользователяСВ(ЧатБот);
	
КонецФункции 

#КонецОбласти
