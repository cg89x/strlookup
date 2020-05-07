#*! version 1.0.0  Christian Kontz 07May2020
program define strlookup, rclass 
	version 9.1

	capt mata mata which mm_invtokens()
    if _rc {
        di as error "mm_invtokens() from -moremata- is required; type {stata ssc install moremata}"
        error 499
    }

    capt which valuesof
    if _rc {
        di as error "-valuesof- is required; type {stata ssc install valuesof}"
        error 499
    }

	return clear

	# delimit  ;
	syntax varlist (min=2 string) 
	, look(string)
	;
	# delimit cr

	tokenize `varlist'

	qui valuesof `1'
	local ccc = r(values)
	local ccc: list uniq ccc

	qui valuesof `2'
	local names = r(values)
	local names: list uniq names

	loc i = 0
	tokenize `"`names'"'
	while "`1'" != "" {
		loc i `++i'
		local a "`: word `i' of `ccc' '"
		local out = cond("`a'"=="`look'", "`1'","")
		
		if "`out'" != ""{
			di "`out'"
			continue, break
		} 
		macro shift
	}

	qui return local in  = "`look'"
	qui return local out = "`out'"
end