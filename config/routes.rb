Habits::Application.routes.draw do
  match 'data.json' => 'data#all', :only => :get
  match 'toggle/:source' => 'data#toggle', :only => :put
end
