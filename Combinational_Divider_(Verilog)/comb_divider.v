module comb_divider #(parameter N=4)(
	input wire					[N-1:0]				a,b,
	input wire												start,				
	output reg					[N-1:0]				m,r,
	output reg												busy, valid
);

	reg					[(2*N)-1:0]					divisor ;
	reg					[(2*N)-1:0]					remainder				[0:N]  ;	
	reg					[(2*N)-1:0]					x								[0:N-1] ;
	reg					[N-1:0]							qutionet ;
	integer 	i  ;
	
always@(*)
	begin
		if(start)
			begin
				valid=1'b1 ;
				busy=1'b1 ;
				m='b0 ;
				r='b0 ;
				remainder[0]=a ;
				divisor=b<<N ;
				for(i=1; i<=N; i=i+1)
					begin
						x[i-1]=(2*remainder[i-1])-divisor ;
						if(x[i-1][(2*N)-1]==1'b0)
							begin
								remainder[i]=x[i-1] ;					
								qutionet[N-i]=1'b1 ;
							end
						else
							begin
								qutionet[N-i]=1'b0 ;
								remainder[i]=2*remainder[i-1] ;
							end						
					end
				m=qutionet ;
				r=remainder[N][(2*N)-1:N] ;						
			end				
		else
			begin
				valid=1'b0 ;
				busy=1'b0 ;
				m='b0 ;
				r='b0 ;
				divisor='b0 ;
				qutionet='b0 ;
				remainder[0]='b0 ;
				for(i=1; i<=N; i=i+1)
					begin
						remainder[i]='b0 ;
						x[i-1]='b0 ;
					end
			end
	end

endmodule