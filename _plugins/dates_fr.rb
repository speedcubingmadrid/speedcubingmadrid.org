module Jekyll
    module DatesFr
        MONTHS = {"01" => "janvier", "02" => "février", "03" => "mars",
                "04" => "avril", "05" => "mai", "06" => "juin",
                "07" => "juillet", "08" => "août", "09" => "septembre",
                "10" => "octobre", "11" => "novembre", "12" => "décembre"}
        SHORT_MONTHS = {"01" => "janv", "02" => "fév", "03" => "mars",
                "04" => "avril", "05" => "mai", "06" => "juin",
                "07" => "juil", "08" => "août", "09" => "sept",
                "10" => "oct", "11" => "nov", "12" => "déc"}

        # http://man7.org/linux/man-pages/man3/strftime.3.html
        def dates_fr(date)
            day = time(date).strftime("%e") # leading zero is replaced by a space
            month = time(date).strftime("%m")
            year = time(date).strftime("%Y")
            day+' '+MONTHS[month]+' '+year
        end

        def dates_fr_short(date)
            day = time(date).strftime("%e") # leading zero is replaced by a space
            month = time(date).strftime("%m")
            year = time(date).strftime("%Y")
            day+' '+SHORT_MONTHS[month]+' '+year
        end

        def html5date(date)
            day = time(date).strftime("%d")
            month = time(date).strftime("%m")
            year = time(date).strftime("%Y")
            year+'-'+month+'-'+day
        end
    end
end

Liquid::Template.register_filter(Jekyll::DatesFr)
