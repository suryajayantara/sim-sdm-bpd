[//lasso
	define_type(
		'dictionary',
		-prototype,
		-description='A basic dictionary type.'
	);	
		define_tag('oncreate');
			local('ivars') = @self->properties->first;
			
			iterate(params, local('i'));
				if(!#i->first->waskeyword && #i->isa('pair'));
					#ivars->insert(#i->first = #i->second);
				/if;
			/iterate;
		/define_tag;

		define_tag('size');
			return(self->properties->first->size);
		/define_tag;

		define_tag('onconvert');
			return(self->properties->first);
		/define_tag;
	
		define_tag('_unknowntag');		
			local('ivars') = @self->properties->first;
			local('maptags') = @#ivars->properties->second;
			
			#maptags->keys >> tag_name ? return(
				@#maptags->find(tag_name)->run(
					-owner=self->properties->first,
					-params=params
				)
			);

			#ivars->keys !>> tag_name ? #ivars->insert(tag_name = dictionary);
			return(@#ivars->find(tag_name));
		/define_tag;
	/define_type;
]
