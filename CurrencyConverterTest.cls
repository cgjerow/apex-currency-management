@isTest
public with sharing class CurrencyConverterTest 
{
    @isTest
    public static void initializeCache()
    {
        Map<String,CurrencyType> result = CurrencyConverter.currencyTypeCache;
        System.assert(result.size()>0,'Type cache not initialized properly.');
    }

    @isTest
    public static void setCacheToNull()
    {
        CurrencyConverter.CurrencyConverterException result;
        try { CurrencyConverter.currencyTypeCache = null; }
        catch(CurrencyConverter.CurrencyConverterException e) { result = e; }
        System.assert(result!=null);
        System.assertEquals('Currency Type Cache cannot be set to NULL.',result.getMessage());
    }

    @isTest
    public static void staticConvert()
    {
        initializeCurrencyTypeCache();
        Decimal result = CurrencyConverter.convert('FROM', 'TO', 100);
        System.assertEquals(25,result);
    }

    @isTest
    public static void staticConvertToCorporateCurrency()
    {
        initializeCurrencyTypeCache();
        Decimal result = CurrencyConverter.convertToCorporateCurrency('TO', 100);
        System.assertEquals(200,result);
    }

    @isTest
    public static void staticConverFromCorporateCurrency()
    {
        initializeCurrencyTypeCache();
        Decimal result = CurrencyConverter.convertFromCorporateCurrency('TO', 100);
        System.assertEquals(50,result);
    }

    @isTest
    public static void convertFrom()
    {
        initializeCurrencyTypeCache();
        Decimal result = new CurrencyConverter('TO').convertFrom('FROM',100);
        System.assertEquals(25,result);
    }

    @isTest
    public static void convertFromCorporateCurrency()
    {
        initializeCurrencyTypeCache();
        Decimal result = new CurrencyConverter('TO').convertFromCorporateCurrency(100);
        System.assertEquals(50,result);
    }

    @isTest
    public static void convertToCorporateCurrency()
    {
        initializeCurrencyTypeCache();
        Decimal result = new CurrencyConverter('TO').convertToCorporateCurrency(100);
        System.assertEquals(200,result);
    }

    @isTest
    public static void createRunningUserCurrencyConverter()
    {
        initializeCurrencyTypeCache();
        Object result = new CurrencyConverter.RunningUserCurrencyConverter();
        System.assert(result instanceof CurrencyConverter, 'RunningUserCurrencyConverter not instance of CurrencyConverter');
    }

    private static void initializeCurrencyTypeCache()
    {
        CurrencyConverter.currencyTypeCache = new Map<String,CurrencyType>();
        CurrencyConverter.currencyTypeCache.put(
            'FROM',
            (CurrencyType)new SObjectBuilder(CurrencyType.sObjectType)
                .put(CurrencyType.IsoCode,'FROM')
                .put(CurrencyType.ConversionRate,2)
                .build().getRecord()
        );
        CurrencyConverter.currencyTypeCache.put(
            'TO',
            (CurrencyType)new SObjectBuilder(CurrencyType.sObjectType)
                .put(CurrencyType.IsoCode,'TO')
                .put(CurrencyType.ConversionRate,.5)
                .build().getRecord()
        );
    }
}

