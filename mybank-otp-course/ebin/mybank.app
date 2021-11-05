{application, mybank,
    [
        {description,"Demo OTP app"},
        {vsn, "1.0"},
        {registered, [mybank_atm,mybank_sup]},
        {applications, [kernel,stdlib]},
        {mod,{mybank_app,[]}},
        {env,[]}
    ]
}.