Factory.define :user_create, :class => User do |u|
  u.sequence(:login) {|n| "login#{n}" }
  u.password {|a| "#{a.login}pass".downcase }
  u.password_confirmation {|a| "#{a.login}pass".downcase }
  u.email {|a| "#{a.login}@example.com".downcase }
end


Factory.define :user_with_password do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
end

Factory.define :user do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
end

#tog_user
Factory.define :user_pending do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'pending'
  u.email {|a| "#{a.login}@example.com".downcase }
end

Factory.define :route do |r|
  r.title "Ruta por defecto"
  r.description "Descripción ruta por defecto"
  #{:latitude=> 40.30720174827845, :longitude => -3.7956905364990234},
  #{:latitude => 40.307381472149565, :longitude => -3.7961196899414062}
  r.encoded_points "_o_uFbjdVc@rA"
  r.distance_unit "km"
  r.distance 0.0658
  #r.user{|user| user.association :user, :login => 'chavez'}
end

#http://facstaff.unca.edu/mcmcclur/GoogleMaps/EncodePolyline/example1.html
Factory.define :route_long, :class => Route do |r|
  r.title "Ruta enorme"
  r.description "Desde Ashville hasta un parque nacional"

  r.encoded_points "_gkxEv}|vNM]kB}B}@q@YKg@IqCGa@EcA?cAGg@Ga@q@q@aAg@UYGa@A]WYYw@cAUe@Oi@MgB?o@Do@\\yANoA?w@Ck@?kFBm@?_BDm@?gBBm@?s@Bo@BmGJ[Ao@?gTRsF?s@F}AIYg@Oo@IeAG]GyAMiDi@w@GkD?yAQs@AkB[MOkA_BYg@[aA}@kBwBaE{B}EYc@{@kBWg@eAk@i@e@k@?[Kc@c@Q]Us@Da@Na@lA]Fi@q@mA@g@Nm@I}@QoAi@{BUn@MbAWn@Yf@Qb@MvB@f@Id@Wn@}@dBU`@Wf@wAzBm@fA]HCc@XoC?s@Fe@f@aBJg@Tg@T[t@sBFs@Ga@Lc@~@oGLc@VmAf@aA\\QbA_@hCsA~@Y\\I~DcAZDb@PrC}@VMj@MXOh@Ir@[f@GFm@LW^]f@Yb@]x@i@uArHBpBmAl@Cd@E`@Vn@h@XbBNp@KhBeCnAaBNYzAoBnChJMd@?h@LX\\ZdC?d@H`@PdATjAF\\?`@YjBgA|AiAe@KMk@Hm@?k@Bc@\\Yr@y@zDaDK}AsB~B_AJwCzCk@BsAnB_AJ_F`DmDaFM_JsBeAfAgAGoCxJjIv@HjHoBn@e@p@wCxA^dAUfCeDjG}DYaAkIcJaFcC{@QuCdCcEJyI[iKwAUyE_J{KoDsFC{Cd@cApHkCyDuSkAaPbAeLnFkGrB{DdDsBL_A{@kC]}EsBp@yB@gIqA}FAw@c@E{CvAiEcEgLs@i@kDtAg@c@q@eQuCyJ{@k@mCCm@w@wCuNm@_@eIWoBiA}A{D]wC_BwE_AgS]{@kFuCcAB{@h@o@dA}AhIoDjDcCxAoAJ{JyCoDNoAa@cD{HiG_FaCBuElAq@kHZqPUwC_A_CiMlD{BFeC}@{@{@wA{DuFRyB]iCkDsBsAyBh@mEtC}BTcC_@uJiOe@aKk@cAsBgA{DWqB{@_DoDyFuLcHaDaBwBsEoPCwAlAaCr@e@lGwBn@cCQwC_EcNUqCTmC~CwKnAwBnBuAjSaFbFmHzFwD~CyEnH]tDqAnEkHhHwGD}Cm@cDyAcC}FaCcCuIoBmAyFv@mK~G_Cx@yJ`AsBe@yHyJwKcDmCcC]cAr@aEFyCbBaJq@mCaB_B{DF}Hw@aBxAi@lCiAtB_AL}HuCgG{@sBqA{CqF_@{Cf@cDvEqI|@oHgAaCwHmCe@_AVaISyCqDiI_GwEYyCvBgHCeFXaAvBqAdIg@hBaAlAwBn@oIq@sF{DyEkCu@qE[a@o@UyCn@sHQaAy@m@eAMuJhCwBA_CeEaEaA}OsJ_CwC_AeCGgAr@cFUyCyFsF_EeAsKhA{DEiTmEcBeBuE{M_H_L?cDlAkHY}CuAmEGyCfHqQ\\uTNcDv@mCr@q@hCg@hPdC`C?jNmE~Ld@xFs@zGsCtJkGnAkBOkC}AyAeDmAeLiBgKuJyBzB}@HiR_@sQsFgByAoAcHmAoBuWBkBy@b@ZoAoA}@eCe@gC]gK}BwF_L}HuGuH}LoJ}CeGkEgO_CsDkDoBiIaAgBmAsDwEiF{BgEuD{JcE]cA?kFg@_DaAgCoCyD}FuDqIoCuDsBwJ}AuFwDaBe@{DMsFhAw@Y{@kAg@oKsFeNgAeJkBsCuPeEaG_CkH_F{IiIeCe@wFCqA}AsAsGaByAcEQgYzG{@KqA}Bw@oI{BmMd@{@xA}AbFuClIiIfFmLrK{DzFwEbF{BfByAdHyJbBmGvAeBrBO~Db@xBc@`A}BtAeHhCgGz@mLlCoHjBkC|@u@rIqDxCeE`@_DUgCuFoIm@yCDuAvDsI`BaHbDqFdBqGv@_@|Fp@l@_@j@oA?uAkD_Nw@uF|DiV`BgB~BgAxHeBn@eAh@}CKkDuDcFWoAm@_KHkHhAsC`ByBrIeGvDiG~BaC~LsHJoAwIt@cHKu@d@kA`CcBdBgRnIyGbGwBt@{KEm@e@U{CdByNw@uEaBsAoFVkF{@{@T}DnDiKrDuJ`@{@e@a@{@]{Cc@w@eHyAoFgF{@WyMJkJ{@wD_AuH|@oHEsFgO_B{AcF}BgC\\oFfC{@Bs@a@sDoH_CgD_F}CaKY{KhEaGrDC_ApBsAtB_ETkCc@{@cE_DsDkHsDmEwE{BoDY{DoHTeAvBHxAxAm@f@y@E"
  r.distance_unit "km"
  r.distance 95.6526
end

Factory.define :waypoint do |r|
  r.lat 40.2910772956
  r.lng -3.7874883413
  r.alt 0.0
  r.position 0
end

Factory.define :near_waypoint, :class => Waypoint do |r|
  r.lat 40.2950772956
  r.lng -3.7824883413
  r.alt 0.0
end

#tog_core
Factory.define :profile do |p|
end

Factory.define :group do |g|
  g.state 'pending'
end

#tog_conversation
Factory.define :blog do |u|
end

Factory.define :bloggership do |u|
end

Factory.define :post do |p|
end

Factory.define :rate do |r|
end