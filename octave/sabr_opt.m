function result = sabr_opt (fwd, strike, tex, atm, beta, rho, nu)
			      # Calculate sigma_B
			      # Input: fwd, strike, T, sigma_atm, beta, rho, nu
			      # Output sigma_B, alpha
  
	
 
  function res_sq = sq(x)
    res_sq = x * x;
  endfunction

  function res_sb = sigmab(alpha)
				# beta, rho, nu, fwd, strike are global
  
    x = log (s /. k) in
        let sk = s *. k in
        let omb = 1. -. beta in
        let z = nu /. alpha *. (s ** omb -. k ** omb) /. omb in
        let exp_den = (sqrt (1. -. 2. *. rho *. z +. sq z) +. z -. rho) /. (1. -. rho) in
        let i0 = if k = s then alpha *. s ** (beta -. 1.) else nu *. x /. log (exp_den) in
        let i1 = (sq (omb *. alpha) /. sk ** omb +. (2. -. 3. *. sq rho) *. sq nu) /. 24. +. 0.25 *. rho *. nu *. alpha *. beta /. sk ** (0.5 *. omb) in
        i0 *. (1. +. i1 *. tau)

let square_root ~a2 ~a1 ~a0 =
  let open Complex in
  let complex_of_real x = {re = x; im = 0.} in
  let delta = a1 *. a1 -. 4. *. a0 *. a2 in
  let sqrt_delta =
    let aux = Pervasives.sqrt (abs_float delta) in
    if delta < 0. then {re = 0.; im = aux}
    else {re = aux; im = 0.}
  in
  let a1 = complex_of_real a1 in
  [mul (complex_of_real (-. 0.5 /. a2)) (add a1 sqrt_delta);
   mul (complex_of_real (0.5 /. a2)) (sub sqrt_delta a1)]

let cbrt x =
  let sign x = if x = 0. then 0. else (x /. (sqrt (x *. x))) in
  (sign x) *. (Pervasives.abs_float x) ** (1. /. 3.)

let real_sotta ~a3 ~a2 ~a1 ~a0 =
  let open Complex in
  let complex_of_real x = {re = x; im = 0.} in
  let j = exp (mul i (complex_of_real (2. *. pi /. 3.))) in
  let j2 = exp (mul i (complex_of_real (4. *. pi /. 3.))) in
  let roots =
    if a3 = 0. then square_root ~a2 ~a1 ~a0
    else
      begin
        if a2 = 0. && a1 = 0. then
          let x1 = complex_of_real (cbrt (-. a0 /. a3)) in
          [x1; mul j x1; mul j2 x1]
        else
          begin
            if abs_float (3. *. a3 *. a1 -. a2 ** 2.) < 1e-10 then
              let aux = complex_of_real (cbrt (a1 ** 3. -. 3. *. a0 *. a1 *. a2)) in
              let one_div_a2 = complex_of_real ( 1. /. a2) in
              let a1 = complex_of_real a1 in
              let x1 = mul one_div_a2 (sub aux a1) in
              let x2 = mul one_div_a2 (sub (mul j aux) a1) in
              let x3 = mul one_div_a2 (sub (mul j2 aux) a1) in
              [x1; x2; x3]
            else
              begin
                if abs_float (3. *. a0 *. a2 -. a1 ** 2.) < 1e-10 then
                  let aux = complex_of_real (cbrt (a2 ** 3. -. 3. *. a1 *. a2 *. a3)) in
                  let a1 = complex_of_real a1 in
                  let a2 = complex_of_real a2 in
                  [div a1 (sub aux a2); div a1 (sub (mul j aux) a2);  div a1 (sub (mul j2 aux) a2)]
                else
                  let sr = square_root ~a2:(3. *. a3 *. a1 -. a2 ** 2.) ~a1:(9. *. a3 *. a0 -. a2 *. a1) ~a0:(3. *. a2 *. a0 -. a1 ** 2.) in
                  let b, c =
                    match sr with
                    | [x1; x2] -> x1, x2
                    | _ -> assert false
                  in
                  let a2 = complex_of_real a2 in
                  let a = add a2 (mul (complex_of_real (3. *. a3)) c) in
                  let f = add a2 (mul (complex_of_real (3. *. a3)) b) in

                  let ca = if a.im = 0. then complex_of_real (cbrt (a.re)) else exp (mul (complex_of_real (1. /. 3.)) (log a)) in
                  let cf = if f.im = 0. then complex_of_real (cbrt (f.re)) else exp (mul (complex_of_real (1. /. 3.)) (log f)) in
                  [div (sub (mul b ca) (mul c cf)) (sub ca cf); div (sub (mul b (mul j ca)) (mul c cf)) (sub (mul j ca) cf); div (sub (mul b (mul j2 ca)) (mul c cf)) (sub (mul j2 ca) cf)]
              end
          end
      end
  in
  let real_roots = List.filter (fun x -> abs_float x.im < 1e-10) roots in
  List.map (fun x -> x.re) real_roots

exception Cannot_match_sigma_atm

let sigma_atm_to_alpha ~sigma_atm ~fwd ~beta ~rho ~nu ~t_ex =
  let one_minus_beta = 1. -. beta in
  let f_power_one_minus_beta = fwd ** one_minus_beta in
  let a3 = (((one_minus_beta /. f_power_one_minus_beta) ** 2.) /. 24.) *. t_ex in
  let a2 = (0.25 *. rho *. beta *. nu /. f_power_one_minus_beta) *. t_ex in
  let a1 = 1. +. ((2. -. 3. *. rho ** 2.) /. 24.) *. nu ** 2. *. t_ex in
  let a0 = -. sigma_atm *. f_power_one_minus_beta in
  let roots = real_sotta ~a3 ~a2 ~a1 ~a0 in
  match Mlfi_list.minimum_opt compare (List.filter ((<=) 0.) roots) with
  | Some m -> m
  | None -> raise Cannot_match_sigma_atm


let black_sigma ~sigmab_formula ~sigma_atm ~fwd ~beta ~rho ~nu ~t_ex =
  let parameters =
    {
     curve = Curve.constant_curve min_date 0.;
     sigmab_formula;
     alpha = sigma_atm_to_alpha ~sigma_atm ~fwd ~beta ~rho ~nu ~t_ex;
     beta;
     nu;
     rho;
    }
  in
  fun strike -> sigmab parameters t_ex strike fwd
