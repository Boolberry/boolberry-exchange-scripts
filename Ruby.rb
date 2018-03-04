block = 991489 # change this to block you want to start with
while true 
	PaymentIds = PaymentAddress.where(currency: 7).pluck(:address) # Peatio code you can change this to anything just gather the payment ids here
	txs = Bbr.bbr("get_bulk_payments",{payment_ids: PaymentIds, min_block_height: block}) # get the TXs 
	if txs.empty?
		sleep 120 # wait for the next block
	else
		block = txs["payments"][0]["block_height"]
		txs["payments"].each do |tx|
			p postData = Net::HTTP.post_form(URI.parse('https://cryptochangex.com/webhooks/bbr'), {'type'=>'transaction', 'block'=>tx["block_height"], 'hash'=>tx["payment_id"]}) # send to your API 
		end
		block += 1
	end
end
