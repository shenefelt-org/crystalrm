class Rack::Attack

  blocklist('block php & wordpress scanners and old Pokemon path') do |request|
    request.path.end_with?('.php') || request.path.include?('/wp') 
    || request.path.include?('.env') || request.path.include?('/pokemon')
  end 

  # add specific ips to the block list array
  blocklist('explicit IP blocking') do |request|
    ['143.244.57.88', '185.247.137.5', '20.92.72.133'].freeze.include?(request.ip)
  end


end 
