heroku pg:reset DATABASE  --confirm yogy
heroku run rake db:migrate
heroku restart
