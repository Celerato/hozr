class LabelPrintController < ApplicationController
  
  def label
      @start_praxnr = params[:start_praxnr]
      @end_praxnr = params[:end_praxnr]
      @cases = Case.find(:all, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr BETWEEN ? AND ? AND praxistar_eingangsnr > '01' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'",@start_praxnr,@end_praxnr ])
      label_save
      set_triger
  end
    
    def label_save
      label_delete
      for label in @cases
        ot_label = OtLabel.new
        ot_label.sys_id=label.id
        ot_label.prax_nr=label.praxistar_eingangsnr
        ot_label.doc_fname=label.doctor.family_name
        ot_label.doc_gname=label.doctor.given_name
        ot_label.pat_fname=label.patient.vcard.family_name
        ot_label.pat_gname=label.patient.vcard.given_name
        ot_label.pat_bday=label.patient.birth_date
        ot_label.save
      end
    end
    
    def label_delete
      OtLabel.delete_all
    end
    
    def set_triger
      system("touch public/triger/triger.txt")
    end
  end