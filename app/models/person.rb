class Person < ApplicationRecord
  self.primary_key = :id

  # List of fields we accept in the db
  @@obj_info = %w(
    wca_id
    name
    s_333
    a_333
    s_222
    a_222
    s_444
    a_444
    s_555
    a_555
    s_666
    a_666
    s_777
    a_777
    s_333bf
    a_333bf
    s_333fm
    a_333fm
    s_333oh
    a_333oh
    s_clock
    a_clock
    s_minx
    a_minx
    s_pyram
    a_pyram
    s_skewb
    a_skewb
    s_sq1
    a_sq1
    s_444bf
    a_444bf
    s_555bf
    a_555bf
    s_333mbf
    a_333mbf
  )

  def self.create_or_update(json_person)
    wca_id = json_person["person"]["wca_id"]
    person = Person.find_by(wca_id: wca_id)
    if person.nil?
      name = json_person["person"]["name"]
      person = Person.create(wca_id: wca_id, name: name)
    end

    pr_333 = json_person["personal_records"]["333"]
    if pr_333
      person.update(s_333: pr_333["single"]["best"]) if pr_333["single"]
      person.update(a_333: pr_333["average"]["best"]) if pr_333["average"]
    end

    pr_222 = json_person["personal_records"]["222"]
    if pr_222
      person.update(s_222: pr_222["single"]["best"]) if pr_222["single"]
      person.update(a_222: pr_222["average"]["best"]) if pr_222["average"]
    end

    pr_444 = json_person["personal_records"]["444"]
    if pr_444
      person.update(s_444: pr_444["single"]["best"]) if pr_444["single"]
      person.update(a_444: pr_444["average"]["best"]) if pr_444["average"]
    end

    pr_555 = json_person["personal_records"]["555"]
    if pr_555
      person.update(s_555: pr_555["single"]["best"]) if pr_555["single"]
      person.update(a_555: pr_555["average"]["best"]) if pr_555["average"]
    end

    pr_666 = json_person["personal_records"]["666"]
    if pr_666
      person.update(s_666: pr_666["single"]["best"]) if pr_666["single"]
      person.update(a_666: pr_666["average"]["best"]) if pr_666["average"]
    end

    pr_777 = json_person["personal_records"]["777"]
    if pr_777
      person.update(s_777: pr_777["single"]["best"]) if pr_777["single"]
      person.update(a_777: pr_777["average"]["best"]) if pr_777["average"]
    end

    pr_333bf = json_person["personal_records"]["333bf"]
    if pr_333bf
      person.update(s_333bf: pr_333bf["single"]["best"]) if pr_333bf["single"]
      person.update(a_333bf: pr_333bf["average"]["best"]) if pr_333bf["average"]
    end

    pr_333fm = json_person["personal_records"]["333fm"]
    if pr_333fm
      person.update(s_333fm: pr_333fm["single"]["best"]) if pr_333fm["single"]
      person.update(a_333fm: pr_333fm["average"]["best"]) if pr_333fm["average"]
    end

    pr_333oh = json_person["personal_records"]["333oh"]
    if pr_333oh
      person.update(s_333oh: pr_333oh["single"]["best"]) if pr_333oh["single"]
      person.update(a_333oh: pr_333oh["average"]["best"]) if pr_333oh["average"]
    end

    pr_clock = json_person["personal_records"]["clock"]
    if pr_clock
      person.update(s_clock: pr_clock["single"]["best"]) if pr_clock["single"]
      person.update(a_clock: pr_clock["average"]["best"]) if pr_clock["average"]
    end

    pr_minx = json_person["personal_records"]["minx"]
    if pr_minx
      person.update(s_minx: pr_minx["single"]["best"]) if pr_minx["single"]
      person.update(a_minx: pr_minx["average"]["best"]) if pr_minx["average"]
    end

    pr_pyram = json_person["personal_records"]["pyram"]
    if pr_pyram
      person.update(s_pyram: pr_pyram["single"]["best"]) if pr_pyram["single"]
      person.update(a_pyram: pr_pyram["average"]["best"]) if pr_pyram["average"]
    end

    pr_skewb = json_person["personal_records"]["skewb"]
    if pr_skewb
      person.update(s_skewb: pr_skewb["single"]["best"]) if pr_skewb["single"]
      person.update(a_skewb: pr_skewb["average"]["best"]) if pr_skewb["average"]
    end

    pr_sq1 = json_person["personal_records"]["sq1"]
    if pr_sq1
      person.update(s_sq1: pr_sq1["single"]["best"]) if pr_sq1["single"]
      person.update(a_sq1: pr_sq1["average"]["best"]) if pr_sq1["average"]
    end

    pr_444bf = json_person["personal_records"]["444bf"]
    if pr_444bf
      person.update(s_444bf: pr_444bf["single"]["best"]) if pr_444bf["single"]
      person.update(a_444bf: pr_444bf["average"]["best"]) if pr_444bf["average"]
    end

    pr_555bf = json_person["personal_records"]["555bf"]
    if pr_555bf
      person.update(s_555bf: pr_555bf["single"]["best"]) if pr_555bf["single"]
      person.update(a_555bf: pr_555bf["average"]["best"]) if pr_555bf["average"]
    end

    pr_333mbf = json_person["personal_records"]["333mbf"]
    if pr_333mbf
      person.update(s_333mbf: pr_333mbf["single"]["best"]) if pr_333mbf["single"]
    end

    person.update(gold: json_person["medals"]["gold"])
    person.update(silver: json_person["medals"]["silver"])
    person.update(bronze: json_person["medals"]["bronze"])
  end
end
