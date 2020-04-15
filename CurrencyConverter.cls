public with sharing virtual class CurrencyConverter 
{
    private static Map<String,CurrencyType> currencyTypeCache
    {
        get
        {
            if (currencyTypeCache==null)
                initializeCurrencyTypeCache();
            return currencyTypeCache;
        }
        set
        {
            if (value==null)
                throw new CurrencyConverterException('Currency Type Cache cannot be set to NULL.');
            currencyTypeCache=value;
        }
    }
    private String isoCode;

    public CurrencyConverter(String isoCode)
    {
        this.isoCode = isoCode;
    }

    public Decimal convertFrom(String isoCode, Decimal amount)
    {
        return convert(isoCode, this.isoCode, amount);
    }

    public Decimal convertToCorporateCurrency(Decimal amount)
    {
        return convertToCorporateCurrency(this.isoCode, amount);
    }

    public Decimal convertFromCorporateCurrency(Decimal amount)
    {
        return convertFromCorporateCurrency(this.isoCode, amount);
    }


    public static Decimal convert(String fromIsoCode, String toIsoCode, Decimal amount)
    {
        Decimal corporateAmount = convertToCorporateCurrency(fromIsoCode, amount);
        return convertFromCorporateCurrency(toIsoCode, corporateAmount);
    }

    public static Decimal convertFromCorporateCurrency(String isoCode, Decimal amount)
    {
        return amount * getCurrencyType(isoCode).ConversionRate;
    }

    public static Decimal convertToCorporateCurrency(String isoCode, Decimal amount)
    {
        return amount / getCurrencyType(isoCode).ConversionRate;
    }

    public static CurrencyType getCurrencyType(String isoCode)
    {
        isoCode = isoCode.toUpperCase();
        return currencyTypeCache.get(isoCode);
    }

    public static List<CurrencyType> getActiveCurrencyTypes()
    {
        try {
            return [
                SELECT
                    ConversionRate,
                    IsCorporate,
                    IsoCode,
                    DecimalPlaces,
                    Id
                FROM CurrencyType
                WHERE IsActive=TRUE
            ];
        }
        catch(Exception e)
        {
            throw new CurrencyConverterException('Error retrieving currency types: '+e.getMessage());
        }
    }


    public class RunningUserCurrencyConverter extends CurrencyConverter
    {
        public RunningUserCurrencyConverter()
        {
            super(UserInfo.getDefaultCurrency());
        }
    }

    public class CurrencyConverterException extends Exception {}


    private static void initializeCurrencyTypeCache()
    {
        currencyTypeCache = new Map<String,CurrencyType>();
        for (CurrencyType currencyType : getActiveCurrencyTypes())
            currencyTypeCache.put(currencyType.IsoCode.toUpperCase(),currencyType);
    }
}

