module HoqExtensions
  module RequirementsLists

    def build_new_primary_requirements_list
      logger.debug("#{name}: Building new primary requirements list")
      self.build_primary_requirements_list
    end

    def build_new_secondary_requirements_list
      logger.debug("#{name}: Building new secondary requirements list")
      self.build_secondary_requirements_list
    end

    def acquire_secondary_requirements_list_from(hoq)
      logger.debug("%s: Acquiring secondary requirements list from %s" %
                   [name, hoq.name])
      update_attributes(:secondary_requirements_list => 
                        hoq.primary_requirements_list)
    end

    def inherit_primary_requirements_list_from(hoq)
      logger.debug("%s: Inheriting primary requirements list from %s" %
                   [name, hoq.name])
      update_attributes(:primary_requirements_list => 
                        hoq.secondary_requirements_list)
    end

    def bequeath_secondary_requirements_list_to(hoq)
      logger.debug("%s: Bequeathing secondary requirements list to %s" %
                   [name, hoq.name])
      hoq.inherit_primary_requirements_list_from(self)
    end

  end
end
